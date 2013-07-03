Timekeeper::Application.routes.draw do
  devise_for :users

  resources :events
  resources :therapists do
    resources :bills
  end
  resources :bills, only: [:show]
  resources :event_categories
  resources :clients
  resources :users
  resources :bill_items
  resources :event_category_prices
  resources :praxis_bills
  resources :notifications
  resources :torgs

  namespace :api do
    resources :events
    resources :clients
    resources :users
    resources :notifications, only: [:index]
  end

  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "events#index"
end