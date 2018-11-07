Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :customers, only: [:index]
  resources :movies, only: [:index, :show, :create]
  resources :rentals, only: [:index]


  post 'rentals/check-out', to: 'rentals#checkout', as: 'checkout'
  patch 'rentals/:id/check-in', to: 'rentals#checkin', as: 'checkin'
end
