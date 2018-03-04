Rails.application.routes.draw do
  root :to => 'home#index'
  get '/auth/twitter/callback', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  get '/login', to: 'home#login'
  
  get '/items/unauth',to:'items#unauthorized'
  resources :items
end
