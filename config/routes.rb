Rails.application.routes.draw do
  get "/" ,to: "servers#index"
  resources :servers, only: [:index, :new, :create]
  resources :logs, only: [:index, :new, :create]
  resources :troubles, only: [:index, :new, :create]
  resources :servers do
    collection do
      get "select"
      get "search"
    end
  end
end
