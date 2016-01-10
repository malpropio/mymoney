require 'rails_helper'

RSpec.describe 'DebtBalances', type: :request do
  describe 'GET /debt_balances' do
    it 'works! (now write some real specs)' do
      get debt_balances_path
      expect(response).to have_http_status(200)
    end
  end
end
