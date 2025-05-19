Rails.application.routes.draw do
  resources :chats, only: [ :show, :create ] do
    resources :messages, only: [ :create ]
  end

  root "chats#create"

  get "up" => "rails/health#show", as: :rails_health_check
end
