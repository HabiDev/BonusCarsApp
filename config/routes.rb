Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  root to: "pages#home"

  devise_for :users, controllers: { registrations: 'users' }

  resources :cards 

  resources :statements  do
    resources :sub_statements
  end

  get :get_card_active_bonus, to: 'bonus_services#get_card_active_bonus', defaults: { format: :turbo_stream }
  get :get_balance_before_active_bonus, to: 'bonus_services#get_balance_before_active_bonus', defaults: { format: :turbo_stream }

end
