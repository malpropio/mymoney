class IncomeDistributionsController < ApplicationController
  before_action :set_income_distribution, only: [:show, :edit, :update, :destroy, :make_payments, :undo_payments]
  before_action :undo_all_payments, only: [:edit, :destroy]

  # GET /income_distributions
  # GET /income_distributions.json
  def index
    @income_distributions = IncomeDistribution.all.order(:distribution_date)
  end

  # GET /income_distributions/1
  # GET /income_distributions/1.json
  def show
  end

  # GET /income_distributions/new
  def new
    @income_distribution = IncomeDistribution.new
  end

  # GET /income_distributions/1/edit
  def edit
  end

  # Make the payments
  def make_payments
    cc_category_id = Category.find_by_name("Credit Cards").id
    loan_category_id = Category.find_by_name("Loans").id
    savings_category_id = Category.find_by_name("Savings").id
    spending_date = @income_distribution.distribution_date
    payment_method_id = PaymentMethod.find_by_name("Debit").id

    Spending.create(description:  "Amex", category_id: cc_category_id, spending_date: spending_date, amount: @income_distribution.amex_alloc, description_loan: "", description_cc: "Amex", payment_method_id: payment_method_id)
    Spending.create(description:  "Freedom", category_id: cc_category_id, spending_date: spending_date, amount: @income_distribution.freedom_alloc, description_loan: "", description_cc: "Freedom", payment_method_id: payment_method_id)
    Spending.create(description:  "Cash", category_id: cc_category_id, spending_date: spending_date, amount: @income_distribution.cash_alloc, description_loan: "", description_cc: "Cash", payment_method_id: payment_method_id)
    Spending.create(description:  "Travel", category_id: cc_category_id, spending_date: spending_date, amount: @income_distribution.travel_alloc, description_loan: "", description_cc: "Travel", payment_method_id: payment_method_id)
    Spending.create(description:  "Express", category_id: cc_category_id, spending_date: spending_date, amount: @income_distribution.express_alloc, description_loan: "", description_cc: "Express", payment_method_id: payment_method_id)
    Spending.create(description:  "Jcp", category_id: cc_category_id, spending_date: spending_date, amount: @income_distribution.jcp_alloc, description_loan: "", description_cc: "Jcp", payment_method_id: payment_method_id)

    Spending.create(description:  "", category_id: loan_category_id, spending_date: spending_date, amount: @income_distribution.student_alloc/2, description_loan: "Tulane", description_cc: "", payment_method_id: payment_method_id)
    Spending.create(description:  "", category_id: loan_category_id, spending_date: spending_date, amount: @income_distribution.car_alloc, description_loan: "Vw", description_cc: "", payment_method_id: payment_method_id)
    Spending.create(description:  "", category_id: loan_category_id, spending_date: spending_date, amount: @income_distribution.student_alloc/2, description_loan: "Usdoe/Glelsi", description_cc: "", payment_method_id: payment_method_id)

    Spending.create(description:  "Boa Savings", category_id: savings_category_id, spending_date: spending_date, amount: @income_distribution.savings_alloc, description_loan: "", description_cc: "", payment_method_id: payment_method_id)
    Spending.create(description:  "Boa Extra Savings", category_id: savings_category_id, spending_date: spending_date, amount: @income_distribution.extra_savings_alloc, description_loan: "", description_cc: "", payment_method_id: payment_method_id)
    Spending.create(description:  "Chase Extra", category_id: savings_category_id, spending_date: spending_date, amount: @income_distribution.chase_extra, description_loan: "", description_cc: "", payment_method_id: payment_method_id)

    @income_distribution.update(:paid => true)
 
    respond_to do |format|
        format.html { redirect_to @income_distribution, notice: 'Payments successfully made.' }
        format.json { render :show, status: :made, location: @income_distribution }
    end
  end

  def undo_payments
    undo_all_payments

    respond_to do |format|
        format.html { redirect_to @income_distribution, notice: 'Payments successfully made.' }
        format.json { render :show, status: :made, location: @income_distribution }
    end
  end

  # POST /income_distributions
  # POST /income_distributions.json
  def create
    @income_distribution = IncomeDistribution.new(income_distribution_params)

    respond_to do |format|
      if @income_distribution.save
        format.html { redirect_to @income_distribution, notice: 'Income distribution was successfully created.' }
        format.json { render :show, status: :created, location: @income_distribution }
      else
        format.html { render :new }
        format.json { render json: @income_distribution.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /income_distributions/1
  # PATCH/PUT /income_distributions/1.json
  def update
    respond_to do |format|
      if @income_distribution.update(income_distribution_params)
        format.html { redirect_to @income_distribution, notice: 'Income distribution was successfully updated.' }
        format.json { render :show, status: :ok, location: @income_distribution }
      else
        format.html { render :edit }
        format.json { render json: @income_distribution.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /income_distributions/1
  # DELETE /income_distributions/1.json
  def destroy
    @income_distribution.destroy
    respond_to do |format|
      format.html { redirect_to income_distributions_url, notice: 'Income distribution was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_income_distribution
      @income_distribution = IncomeDistribution.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def income_distribution_params
      params.require(:income_distribution).permit(:distribution_date, :boa_chk, :chase_chk)
    end 

    # Destroy spending
    def destroy_spending(spending = nil)
      spending.destroy unless spending.nil? 
    end

    def undo_all_payments
      cc_category_id = Category.find_by_name("Credit Cards").id
      loan_category_id = Category.find_by_name("Loans").id
      savings_category_id = Category.find_by_name("Savings").id
      spending_date = @income_distribution.distribution_date
      payment_method_id = PaymentMethod.find_by_name("Debit").id

      destroy_spending(Spending.find_by(description: "Amex", category_id: cc_category_id, spending_date: spending_date, payment_method_id: payment_method_id))
      destroy_spending(Spending.find_by(description: "Freedom", category_id: cc_category_id, spending_date: spending_date, payment_method_id: payment_method_id))
      destroy_spending(Spending.find_by(description: "Cash", category_id: cc_category_id, spending_date: spending_date, payment_method_id: payment_method_id))
      destroy_spending(Spending.find_by(description: "Travel", category_id: cc_category_id, spending_date: spending_date, payment_method_id: payment_method_id))
      destroy_spending(Spending.find_by(description: "Express", category_id: cc_category_id, spending_date: spending_date, payment_method_id: payment_method_id))
      destroy_spending(Spending.find_by(description: "Jcp", category_id: cc_category_id, spending_date: spending_date, payment_method_id: payment_method_id))

      destroy_spending(Spending.find_by(description: "Tulane", category_id: loan_category_id, spending_date: spending_date, payment_method_id: payment_method_id))
      destroy_spending(Spending.find_by(description: "Vw", category_id: loan_category_id, spending_date: spending_date, payment_method_id: payment_method_id))
      destroy_spending(Spending.find_by(description: "Usdoe/Glelsi", category_id: loan_category_id, spending_date: spending_date, payment_method_id: payment_method_id))

      destroy_spending(Spending.find_by(description: "Boa Savings", category_id: savings_category_id, spending_date: spending_date, payment_method_id: payment_method_id))
      destroy_spending(Spending.find_by(description: "Boa Extra Savings", category_id: savings_category_id, spending_date: spending_date, payment_method_id: payment_method_id))
      destroy_spending(Spending.find_by(description: "Chase Extra", category_id: savings_category_id, spending_date: spending_date, payment_method_id: payment_method_id))
    
      @income_distribution.update(:paid => false)
    end
end
