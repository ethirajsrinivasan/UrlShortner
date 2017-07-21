Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :url_shortners do
    member do
      get :stats
    end
  end
  get "/:short_url", to: "url_shortners#show"
  root "url_shortners#index"
end
