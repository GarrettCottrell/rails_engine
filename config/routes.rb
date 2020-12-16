Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do 
    namespace :v1 do
      get '/merchants/find', to: 'merchants/search#show'
      resources :merchants do
        get :items, to: 'merchants/items#index'
      end
      resources :items do
        get :merchants, to: 'items/merchants#index'
      end
    end
  end
end
