require 'rails_helper'

RSpec.describe IncomeSourcesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/income_sources').to route_to('income_sources#index')
    end

    it 'routes to #new' do
      expect(get: '/income_sources/new').to route_to('income_sources#new')
    end

    it 'routes to #show' do
      expect(get: '/income_sources/1').to route_to('income_sources#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/income_sources/1/edit').to route_to('income_sources#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/income_sources').to route_to('income_sources#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/income_sources/1').to route_to('income_sources#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/income_sources/1').to route_to('income_sources#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/income_sources/1').to route_to('income_sources#destroy', id: '1')
    end
  end
end
