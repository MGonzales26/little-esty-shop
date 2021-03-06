Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :merchants, only: [:index] do
    resources :dashboard, only: [:index]
    resources :items, only: [:index, :show, :edit, :update, :new, :create]
    resources :invoices, only: [:index, :show]
    resources :invoice_item, only: [:update]
    resources :bulk_discounts, only: [:index, :show, :new, :create]
  end

  resources :admin, only: :index

  namespace :admin do
    resources :merchants, only: [ :show, :update, :create, :index, :edit, :update, :new ]
    resources :invoices, only: [ :index, :show, :update ]
  end
end
