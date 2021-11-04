Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get('/', {to: 'welcome#index', as: 'root'})

  resources :users, only:[:new, :create]
  resource :session, only:[:new, :create, :destroy]
  get('/admin', {to: 'users#admin',as: 'admin'})
end
