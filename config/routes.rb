Rails.application.routes.draw do
  get 'facilities/index'
  get 'facilities/show'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :facilities
end
