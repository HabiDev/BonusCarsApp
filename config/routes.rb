Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  root to: "pages#home"

  devise_for :users, controllers: { registrations: 'users' }

  resources :cards do
    collection do 
      post :import
      get :import_file
    end
  end

  resources :statements  do
    patch :copy, on: :member, defaults: { format: :turbo_stream }
    post :import
    get :import_file
    resources :sub_statements
  end

  get :get_card_active_bonus, to: 'bonus_services#get_card_active_bonus', defaults: { format: :turbo_stream }
  get :get_statement_bonus, to: 'bonus_services#get_statement_bonus', defaults: { format: :turbo_stream }
  get :get_cancel_statement_bonus, to: 'bonus_services#get_cancel_statement_bonus', defaults: { format: :turbo_stream }

end
