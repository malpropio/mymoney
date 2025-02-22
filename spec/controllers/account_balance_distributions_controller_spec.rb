require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe AccountBalanceDistributionsController, type: :controller do
  # This should return the minimal set of attributes required to create a valid
  # AccountBalanceDistribution. As you add validations to AccountBalanceDistribution, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    skip('Add a hash of attributes valid for your model')
  end

  let(:invalid_attributes) do
    skip('Add a hash of attributes invalid for your model')
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # AccountBalanceDistributionsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe 'GET #index' do
    it 'assigns all account_balance_distributions as @account_balance_distributions' do
      account_balance_distribution = AccountBalanceDistribution.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:account_balance_distributions)).to eq([account_balance_distribution])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested account_balance_distribution as @account_balance_distribution' do
      account_balance_distribution = AccountBalanceDistribution.create! valid_attributes
      get :show, { id: account_balance_distribution.to_param }, valid_session
      expect(assigns(:account_balance_distribution)).to eq(account_balance_distribution)
    end
  end

  describe 'GET #new' do
    it 'assigns a new account_balance_distribution as @account_balance_distribution' do
      get :new, {}, valid_session
      expect(assigns(:account_balance_distribution)).to be_a_new(AccountBalanceDistribution)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested account_balance_distribution as @account_balance_distribution' do
      account_balance_distribution = AccountBalanceDistribution.create! valid_attributes
      get :edit, { id: account_balance_distribution.to_param }, valid_session
      expect(assigns(:account_balance_distribution)).to eq(account_balance_distribution)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new AccountBalanceDistribution' do
        expect do
          post :create, { account_balance_distribution: valid_attributes }, valid_session
        end.to change(AccountBalanceDistribution, :count).by(1)
      end

      it 'assigns a newly created account_balance_distribution as @account_balance_distribution' do
        post :create, { account_balance_distribution: valid_attributes }, valid_session
        expect(assigns(:account_balance_distribution)).to be_a(AccountBalanceDistribution)
        expect(assigns(:account_balance_distribution)).to be_persisted
      end

      it 'redirects to the created account_balance_distribution' do
        post :create, { account_balance_distribution: valid_attributes }, valid_session
        expect(response).to redirect_to(AccountBalanceDistribution.last)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved account_balance_distribution as @account_balance_distribution' do
        post :create, { account_balance_distribution: invalid_attributes }, valid_session
        expect(assigns(:account_balance_distribution)).to be_a_new(AccountBalanceDistribution)
      end

      it "re-renders the 'new' template" do
        post :create, { account_balance_distribution: invalid_attributes }, valid_session
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        skip('Add a hash of attributes valid for your model')
      end

      it 'updates the requested account_balance_distribution' do
        account_balance_distribution = AccountBalanceDistribution.create! valid_attributes
        put :update, { id: account_balance_distribution.to_param, account_balance_distribution: new_attributes }, valid_session
        account_balance_distribution.reload
        skip('Add assertions for updated state')
      end

      it 'assigns the requested account_balance_distribution as @account_balance_distribution' do
        account_balance_distribution = AccountBalanceDistribution.create! valid_attributes
        put :update, { id: account_balance_distribution.to_param, account_balance_distribution: valid_attributes }, valid_session
        expect(assigns(:account_balance_distribution)).to eq(account_balance_distribution)
      end

      it 'redirects to the account_balance_distribution' do
        account_balance_distribution = AccountBalanceDistribution.create! valid_attributes
        put :update, { id: account_balance_distribution.to_param, account_balance_distribution: valid_attributes }, valid_session
        expect(response).to redirect_to(account_balance_distribution)
      end
    end

    context 'with invalid params' do
      it 'assigns the account_balance_distribution as @account_balance_distribution' do
        account_balance_distribution = AccountBalanceDistribution.create! valid_attributes
        put :update, { id: account_balance_distribution.to_param, account_balance_distribution: invalid_attributes }, valid_session
        expect(assigns(:account_balance_distribution)).to eq(account_balance_distribution)
      end

      it "re-renders the 'edit' template" do
        account_balance_distribution = AccountBalanceDistribution.create! valid_attributes
        put :update, { id: account_balance_distribution.to_param, account_balance_distribution: invalid_attributes }, valid_session
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested account_balance_distribution' do
      account_balance_distribution = AccountBalanceDistribution.create! valid_attributes
      expect do
        delete :destroy, { id: account_balance_distribution.to_param }, valid_session
      end.to change(AccountBalanceDistribution, :count).by(-1)
    end

    it 'redirects to the account_balance_distributions list' do
      account_balance_distribution = AccountBalanceDistribution.create! valid_attributes
      delete :destroy, { id: account_balance_distribution.to_param }, valid_session
      expect(response).to redirect_to(account_balance_distributions_url)
    end
  end
end
