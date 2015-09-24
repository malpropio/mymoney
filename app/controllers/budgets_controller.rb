class BudgetsController < ApplicationController
  include SpendingsHelper

  before_action :set_budget, only: [:show, :edit, :update, :destroy]
  
  FLOOR = "2014-01-01"  


  # GET /budgets
  # GET /budgets.json
  def index
    @budgets = Budget.order(:budget_month => :desc)
                     .order(:category_id)
                     .where("budget_month >= '#{FLOOR}'")
                     .paginate(:per_page => Category.count, :page => params[:page])
  end

  # GET /budgets/1
  # GET /budgets/1.json
  def show
    @spendings = @budget.spendings
                        .order(sort_column + " " + sort_direction)
                        .order(updated_at: :desc)
  end

  # GET /budgets/new
  def new
    @budget = Budget.new
  end

  # GET /budgets/1/edit
  def edit
  end

  def budgets_by_month
    subquery = Spending.joins(:category)
                        .where("categories.name NOT IN ('Credit Cards')")
                        .select("SUM(amount) AS total_spending, budget_id").group(:budget_id).to_sql

    payments_subquery = Spending.joins(:category)
                        .where("categories.name IN ('Credit Cards','Rent','Utilities','Loans')")
                        .select("SUM(amount) AS total_payment, budget_id").group(:budget_id).to_sql
   
    agg = Budget.joins("INNER JOIN categories ON categories.id = budgets.category_id")
                .joins("LEFT OUTER JOIN (#{subquery}) spendings ON budgets.id = spendings.budget_id")
                .joins("LEFT OUTER JOIN (#{payments_subquery}) payments ON budgets.id = payments.budget_id")
                .select("budgets.budget_month, Sum(CASE WHEN categories.name IN ('Credit Cards') THEN 0 ELSE spendings.total_spending END) AS total_spending, Sum(CASE WHEN categories.name IN ('Credit Cards') THEN 0 ELSE budgets.amount END) AS total_budget, Sum(payments.total_payment) AS total_payment ")
                .where("budgets.budget_month >= DATE_ADD(NOW(), INTERVAL - 24 MONTH)")
                .group("budgets.budget_month")
                .having("Sum(CASE WHEN categories.name IN ('Credit Cards') THEN 0 ELSE spendings.total_spending END)>0 AND Sum(CASE WHEN categories.name IN ('Credit Cards') THEN 0 ELSE budgets.amount END)>0 AND Sum(payments.total_payment)>0")
    
    h1 = Hash.new

    agg.each do |budget| 
      h1.store(["Budget", budget.budget_month.strftime('%b %Y')],budget.total_budget) 
      h1.store(["Spending", budget.budget_month.strftime('%b %Y')],budget.total_spending)
      h1.store(["Payment", budget.budget_month.strftime('%b %Y')],budget.total_payment)
    end
    
    render json: h1.chart_json
  end
  
  # Reset all budgets
  def reset

    str = <<-END_SQL
       UPDATE spendings SET budget_id = null;
    END_SQL

    ActiveRecord::Base.connection.execute("#{str}")

    Budget.delete_all
    
    ## Reset the index on the budget table
    ActiveRecord::Base.connection.execute("ALTER TABLE budgets AUTO_INCREMENT = 1")
    
      ## The average up to the previous month is used as budget for the current month
    str = <<-END_SQL
        INSERT INTO budgets (category_id, budget_month, amount, created_at, updated_at)
    SELECT dr.category_id, DATE_ADD(dr.month, INTERVAL 1 MONTH), COALESCE(AVG(base.sum_amount),0), NOW(), NOW()
    FROM
    (
    SELECT DATE_FORMAT(spending_date, '%Y-%m-01 00:00:00') AS month, 
    categories.id AS category_id,
    SUM(CASE WHEN spendings.category_id = categories.id THEN spendings.amount END) AS sum_amount
    FROM spendings 
    JOIN categories
    WHERE DATE_FORMAT(spending_date, '%Y-%m')<DATE_FORMAT(NOW(), '%Y-%m')
    GROUP BY DATE_FORMAT(spending_date, '%Y-%m-01 00:00:00'), categories.id
    ) dr
    LEFT OUTER JOIN
    (
    SELECT DATE_FORMAT(spending_date, '%Y-%m-01 00:00:00') AS month, 
    category_id,
    SUM(spendings.amount) AS sum_amount
    FROM spendings 
    GROUP BY DATE_FORMAT(spending_date, '%Y-%m-01 00:00:00'), category_id
    ) base
    ON base.month <= dr.month
    AND base.category_id = dr.category_id
    GROUP BY dr.month, dr.category_id;
    END_SQL
    
    ActiveRecord::Base.connection.execute("#{str}")
   

    str = <<-END_SQL
      UPDATE spendings AS s
      JOIN budgets AS b
      ON s.category_id = b.category_id 
      AND DATE_FORMAT(s.spending_date, '%Y-%m') = DATE_FORMAT(b.budget_month, '%Y-%m')
      SET budget_id = b.id;
    END_SQL
   
    ActiveRecord::Base.connection.execute("#{str}")
 
    respond_to do |format|
      format.html { redirect_to budgets_url, notice: 'Budgets were successfully set.' }
      format.json { head :no_content }
    end
  end


  # Reset current month's budgets
  def reset_current_month

    str = <<-END_SQL
       UPDATE spendings s JOIN budgets b ON s.budget_id = b.id SET budget_id = null WHERE DATE_FORMAT(b.budget_month, '%Y-%m')=DATE_FORMAT(NOW(), '%Y-%m');
    END_SQL

    ActiveRecord::Base.connection.execute("#{str}")

    str = <<-END_SQL
       DELETE FROM budgets WHERE DATE_FORMAT(budget_month, '%Y-%m')=DATE_FORMAT(NOW(), '%Y-%m');
    END_SQL

    ActiveRecord::Base.connection.execute("#{str}")

      ## The average up to the previous month is used as budget for the current month
    str = <<-END_SQL
    INSERT INTO budgets (category_id, budget_month, amount, created_at, updated_at)
    SELECT dr.category_id, dr.month, COALESCE(AVG(base.sum_amount),0), NOW(), NOW()
    FROM
    (
    SELECT DATE_FORMAT(NOW(), '%Y-%m-01 00:00:00') AS month, 
    categories.id AS category_id
    FROM categories
    ) dr
    LEFT OUTER JOIN
    (
    SELECT DATE_FORMAT(spending_date, '%Y-%m-01 00:00:00') AS month, 
    category_id,
    SUM(spendings.amount) AS sum_amount
    FROM spendings 
    GROUP BY DATE_FORMAT(spending_date, '%Y-%m-01 00:00:00'), category_id
    ) base
    ON base.month <= dr.month
    AND base.category_id = dr.category_id
    GROUP BY dr.month, dr.category_id;
    END_SQL
    
    ActiveRecord::Base.connection.execute("#{str}")
   
    str = <<-END_SQL
      UPDATE spendings AS s
      JOIN budgets AS b
      ON s.category_id = b.category_id 
      AND DATE_FORMAT(s.spending_date, '%Y-%m') = DATE_FORMAT(b.budget_month, '%Y-%m')
      SET budget_id = b.id
      WHERE DATE_FORMAT(spending_date, '%Y-%m')=DATE_FORMAT(NOW(), '%Y-%m');
    END_SQL
   
    ActiveRecord::Base.connection.execute("#{str}")
 
    respond_to do |format|
      format.html { redirect_to budgets_url, notice: 'Budgets were successfully set.' }
      format.json { head :no_content }
    end
  end


  # POST /budgets
  # POST /budgets.json
  def create
    @budget = Budget.new(budget_params)

    respond_to do |format|
      if @budget.save
        format.html { redirect_to @budget, notice: 'Budget was successfully created.' }
        format.json { render :show, status: :created, location: @budget }
      else
        format.html { render :new }
        format.json { render json: @budget.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /budgets/1
  # PATCH/PUT /budgets/1.json
  def update
    respond_to do |format|
      if @budget.update(budget_params)
        format.html { redirect_to @budget, notice: 'Budget was successfully updated.' }
        format.json { render :show, status: :ok, location: @budget }
      else
        format.html { render :edit }
        format.json { render json: @budget.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /budgets/1
  # DELETE /budgets/1.json
  def destroy
    @budget.destroy
    respond_to do |format|
      format.html { redirect_to budgets_url, notice: 'Budget was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_budget
      @budget = Budget.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def budget_params
      params.require(:budget).permit(:category_id, :budget_month, :amount)
    end

    def get_month
      number = params[:page].nil ? 0 : params[:page] - 1
      Time.new.to_date.change(day: 1) - number.months
    end
end
