require "rails_helper"

RSpec.describe IncomeDistributionsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/income_distributions").to route_to("income_distributions#index")
    end

    it "routes to #new" do
      expect(:get => "/income_distributions/new").to route_to("income_distributions#new")
    end

    it "routes to #show" do
      expect(:get => "/income_distributions/1").to route_to("income_distributions#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/income_distributions/1/edit").to route_to("income_distributions#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/income_distributions").to route_to("income_distributions#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/income_distributions/1").to route_to("income_distributions#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/income_distributions/1").to route_to("income_distributions#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/income_distributions/1").to route_to("income_distributions#destroy", :id => "1")
    end

  end
end
