Rails.application.routes.draw do
  resources :promotes
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post '/callback' => 'webhook#callback'
end
