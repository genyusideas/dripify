Dripify::Application.routes.draw do
  
  # devise_for :users
  devise_for(:users, controllers:{ sessions: "sessions" })

  resources :users, only: [:show] do
    collection { get 'get_current_user' }
    resources :twitter_accounts, only: [:index, :show, :create, :destroy] do
      resources :drip_marketing_campaigns, only: [:index, :show, :create] do
        resources :drip_marketing_rules, only: [:index, :create, :update]
      end
    end
  end

  root to: "static_pages#home"
end
