Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      get '/merchants/find', to: 'merchants/search#show'
      get '/merchants/find_all', to: 'merchants/search#index'
      get '/items/find', to: 'items/search#show'
      get '/items/find_all', to: 'items/search#index'
      get '/merchants/most_revenue', to: 'merchants/bi/revenue#index'
      get '/merchants/most_items', to: 'merchants/bi/most_items#index'
      resources :merchants do
        get :items, to: 'merchants/items#index'
      end
      resources :items do
        get :merchants, to: 'items/merchants#index'
      end
    end
  end
end
