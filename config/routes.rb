Rails.application.routes.draw do

  root to: "pages#home"
  get "pages/home", to: "pages#home"

  resources :uploads, only: %i[new create]
  resources :rulesets, only: %i[index create]
  resource :government_ruleset, only: %i[show create]
  resource :security_ruleset, only: %i[show create]
  resources :rules, only: %i[show]

  scope via: :all do
    get "/404", to: "errors#not_found"
    get "/422", to: "errors#unprocessable_entity"
    get "/429", to: "errors#too_many_requests"
    get "/500", to: "errors#internal_server_error"
  end
end
