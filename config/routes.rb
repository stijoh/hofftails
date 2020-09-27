Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'pages#home'
  get 'search', to: 'cocktails#search'
  post 'search', to: 'cocktails#search'
  resources :cocktails, only: %i[index new create show update] do
    resources :doses, only: %i[new create]
  end

  resources :doses, only: :destroy
end
