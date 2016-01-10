Rails.application.routes.draw do
  resources :account_balance_distributions
  resources :account_balances do
    member do
      get :make_payments
      get :undo_payments
    end
  end
  resources :accounts
  resources :income_sources
  resources :income_distributions do
    member do
      get :make_payments
      get :undo_payments
    end
  end

  root	'static_pages#home'
  get	'home'		=>	'static_pages#home'
  get	'signup'	=> 	'users#new'
  get 'login'   	=> 	'sessions#new'
  post 'login'   	=> 	'sessions#create'
  delete 'logout'  	=> 	'sessions#destroy'
  get	'curr_alloc'  =>      'allocations#show_curr'
  get 'authorize' => 'application#authorize'

  resources :categories

  resources :users do
    member do
      get :add_contributor
      get :remove_contributor
    end
  end

  resources :spendings do
    collection do
      get :spendings_by_day
      get :spendings_by_month
      get :spendings_by_category
      get :spendings_by_payment_method
      get :cc_purchase_vs_payment
    end
  end

  resources :budgets do
    collection do
      get :reset
      get :reset_current_month
      get :budgets_by_month
    end
  end

  resources :payment_methods

  resources :debts

  resources :debt_balances do
    collection do
      get :ccs_by_month
      get :loans_by_month
    end

    member do
      get :close
    end
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
