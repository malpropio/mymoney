require 'rails_helper'

RSpec.describe "AccountBalanceDistributions", type: :request do
  describe "GET /account_balance_distributions" do
    it "works! (now write some real specs)" do
      get account_balance_distributions_path
      expect(response).to have_http_status(200)
    end
  end
end
