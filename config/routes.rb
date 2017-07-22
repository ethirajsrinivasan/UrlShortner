Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :url_shortners do
    member do
      get :stats
    end
    collection do
      get :fetch_short_url
    end
  end
  post 'authenticate', to: 'authentication#authenticate'
  get "/:short_url", to: "url_shortners#show"
  root "url_shortners#index"
end
