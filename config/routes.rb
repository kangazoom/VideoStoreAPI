Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :customers, only: [:index]
  resources :movies, only: [:index, :show, :create]

  post 'rentals/checkout', to: 'rentals#checkout', as: 'checkout'
  patch 'rentals/:id/checkin', to: 'rentals#checkin', as: 'checkin'
  resources :rentals, only: [:index, :create]
end
