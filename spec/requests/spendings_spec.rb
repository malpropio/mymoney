require 'rails_helper'

RSpec.describe 'Spendings', type: :request do
  describe 'GET /spendings' do
    it 'works! (now write some real specs)' do
      get spendings_path
      expect(response).to have_http_status(302)
    end
  end
end
