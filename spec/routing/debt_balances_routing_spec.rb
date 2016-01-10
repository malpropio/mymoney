require 'rails_helper'

RSpec.describe DebtBalancesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/debt_balances').to route_to('debt_balances#index')
    end

    it 'routes to #new' do
      expect(get: '/debt_balances/new').to route_to('debt_balances#new')
    end

    it 'routes to #show' do
      expect(get: '/debt_balances/1').to route_to('debt_balances#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/debt_balances/1/edit').to route_to('debt_balances#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/debt_balances').to route_to('debt_balances#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/debt_balances/1').to route_to('debt_balances#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/debt_balances/1').to route_to('debt_balances#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/debt_balances/1').to route_to('debt_balances#destroy', id: '1')
    end
  end
end
