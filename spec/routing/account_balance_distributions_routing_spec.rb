require 'rails_helper'

RSpec.describe AccountBalanceDistributionsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/account_balance_distributions').to route_to('account_balance_distributions#index')
    end

    it 'routes to #new' do
      expect(get: '/account_balance_distributions/new').to route_to('account_balance_distributions#new')
    end

    it 'routes to #show' do
      expect(get: '/account_balance_distributions/1').to route_to('account_balance_distributions#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/account_balance_distributions/1/edit').to route_to('account_balance_distributions#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/account_balance_distributions').to route_to('account_balance_distributions#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/account_balance_distributions/1').to route_to('account_balance_distributions#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/account_balance_distributions/1').to route_to('account_balance_distributions#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/account_balance_distributions/1').to route_to('account_balance_distributions#destroy', id: '1')
    end
  end
end
