require 'rails_helper'

RSpec.describe "IncomeDistributions", type: :request do
  describe "GET /income_distributions" do
    it "works! (now write some real specs)" do
      get income_distributions_path
      expect(response).to have_http_status(200)
    end
  end
end
