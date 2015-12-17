class IncomeDistributionsController < ApplicationController
  include IncomeDistributionsHelper

  before_action :set_income_distribution, only: [:show, :edit, :update, :destroy, :make_payments, :undo_payments]
  before_action :undo_all_payments, only: [:destroy]

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
    make_all_payments
 
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
      params.require(:income_distribution).permit(:distribution_date, :boa_chk, :chase_chk, :boa_focus, :chase_focus)
    end 

    # Destroy spending
    def destroy_spending(spending = nil)
      spending.destroy unless spending.nil? 
    end
    
    def make_all_payments
      spending_date = @income_distribution.distribution_date
      payment_method_id = PaymentMethod.find_by_name("Debit").id

      c = @income_distribution.debts_hash

      c.map do |k,v|
        unless Debt.do_not_pay_list.include? k 
          id = nil || Category.find_by_name(k).id if Category.exists?(name: k)
          id = id || Category.find_by_name(Debt.find_by_name(k).category).id if Debt.exists?(name: k)
          payment = Spending.create(description: k, category_id: id, spending_date: spending_date, amount: v[1], description_loan: k, description_cc: k, payment_method_id: payment_method_id, description_asset: k)
        end
      end

      @income_distribution.update(:paid => true)
    end
    
    def undo_all_payments
      spending_date = @income_distribution.distribution_date
      payment_method_id = PaymentMethod.find_by_name("Debit").id

      c = @income_distribution.debts_hash
      
      c.map do |k,v|
        unless Debt.do_not_pay_list.include? k
          id = nil || Category.find_by_name(k).id if Category.exists?(name: k)
          id = id || Category.find_by_name(Debt.find_by_name(k).category) if Debt.exists?(name: k)
          destroy_spending(Spending.find_by(description: k, category_id: id, spending_date: spending_date, payment_method_id: payment_method_id))
        end
      end

      @income_distribution.update(:paid => false)
    end
end
