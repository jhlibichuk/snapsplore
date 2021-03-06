Snapsplore::Application.routes.draw do
  get "users/show"

  devise_for :users, controllers: { omniauth_callbacks: "omniauth_callbacks", registrations: "registrations" }

  #get "/games", to: "bearded#faq", as: "faq"
  #get "/explore", to: "bearded#faq", as: "faq"

  get "/explore", to: "explore#index", as: "explore"
  get "/entries/full/:id", to: "entries#full", as: "full"
  get "/entries/explore/:id", to: "entries#explore", as: "explore_entry"
  get "/users/:id", to: "users#show", as: "show_user"
  resources :entries
  resources :list_items do 
    resources :entries
  end
  resources :games
  root to: "home#index"

end
