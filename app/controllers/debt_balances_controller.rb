class DebtBalancesController < ApplicationController
  before_action :set_debt_balance, only: [:show, :edit, :update, :destroy]

  # GET /debt_balances
  # GET /debt_balances.json
  def index
    @debt_balances = DebtBalance.order(:due_date => :desc)
                     .paginate(:per_page => 25, :page => params[:page])
  end

  def ccs_by_month
    render json: DebtBalance.joins(:debt)
                         .where("debts.category = 'Credit Cards'")
                         .group("debts.name")
                         .group_by_month(:due_date, format: "%b %Y").having("sum(debt_balances.balance) > ?", 0)
                         .sum(:balance)
                         .chart_json
  end

  def loans_by_month
    render json: DebtBalance.joins(:debt)
                         .where("debts.category = 'Loans'")
                         .group("debts.name")
                         .group_by_month(:due_date, format: "%b %Y").having("sum(debt_balances.balance) > ?", 0)
                         .sum(:balance)
                         .chart_json
  end
  
  # GET /debt_balances/1
  # GET /debt_balances/1.json
  def show
  end

  # GET /debt_balances/new
  def new
    @debt_balance = DebtBalance.new
  end

  # GET /debt_balances/1/edit
  def edit
  end

  # POST /debt_balances
  # POST /debt_balances.json
  def create
    @debt_balance = DebtBalance.new(debt_balance_params)

    respond_to do |format|
      if @debt_balance.save
        format.html { redirect_to @debt_balance, notice: 'Debt balance was successfully created.' }
        format.json { render :show, status: :created, location: @debt_balance }
      else
        format.html { render :new }
        format.json { render json: @debt_balance.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /debt_balances/1
  # PATCH/PUT /debt_balances/1.json
  def update
    respond_to do |format|
      if @debt_balance.update(debt_balance_params)
        format.html { redirect_to @debt_balance, notice: 'Debt balance was successfully updated.' }
        format.json { render :show, status: :ok, location: @debt_balance }
      else
        format.html { render :edit }
        format.json { render json: @debt_balance.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /debt_balances/1
  # DELETE /debt_balances/1.json
  def destroy
    @debt_balance.destroy
    respond_to do |format|
      format.html { redirect_to debt_balances_url, notice: 'Debt balance was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_debt_balance
      @debt_balance = DebtBalance.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def debt_balance_params
      params.require(:debt_balance).permit(:debt_id, :due_date, :balance, :payment_start_date)
    end
end
