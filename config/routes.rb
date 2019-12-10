Rails.application.routes.draw do
  root 'static_pages#home'

  get 'signup' => 'users#new'

  resources :users
  resources :trips
  resources :grouped_trips

  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

end
