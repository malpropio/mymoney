class AccountBalanceDistributionsController < ApplicationController
  before_action :set_account_balance_distribution, only: [:show, :edit, :update, :destroy]

  # GET /account_balance_distributions
  # GET /account_balance_distributions.json
  def index
    @account_balance_distributions = current_user.get_account_balance_distributions
  end

  # GET /account_balance_distributions/1
  # GET /account_balance_distributions/1.json
  def show
  end

  # GET /account_balance_distributions/new
  def new
    @account_balance_distribution = AccountBalanceDistribution.new
  end

  # GET /account_balance_distributions/1/edit
  def edit
  end

  # POST /account_balance_distributions
  # POST /account_balance_distributions.json
  def create
    @account_balance_distribution = AccountBalanceDistribution.new(account_balance_distribution_params)

    respond_to do |format|
      if @account_balance_distribution.save
        format.html { redirect_to @account_balance_distribution, notice: 'Account balance distribution was successfully created.' }
        format.json { render :show, status: :created, location: @account_balance_distribution }
      else
        format.html { render :new }
        format.json { render json: @account_balance_distribution.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account_balance_distributions/1
  # PATCH/PUT /account_balance_distributions/1.json
  def update
    respond_to do |format|
      if @account_balance_distribution.update(account_balance_distribution_params)
        format.html { redirect_to @account_balance_distribution, notice: 'Account balance distribution was successfully updated.' }
        format.json { render :show, status: :ok, location: @account_balance_distribution }
      else
        format.html { render :edit }
        format.json { render json: @account_balance_distribution.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account_balance_distributions/1
  # DELETE /account_balance_distributions/1.json
  def destroy
    @account_balance_distribution.destroy
    respond_to do |format|
      format.html { redirect_to account_balance_distributions_url, notice: 'Account balance distribution was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_account_balance_distribution
      @account_balance_distribution = AccountBalanceDistribution.find(params[:id])
      authorize @account_balance_distribution
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def account_balance_distribution_params
      params.require(:account_balance_distribution).permit(:account_balance_id, :debt_id, :recommendation, :actual)
    end
end
