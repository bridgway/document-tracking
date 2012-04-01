Documents::Application.routes.draw do
  root :to => 'documents#index'

  resources :documents

  get '/login' => 'sessions#new', :as => :new_session
  post '/login' => 'sessions#create'
end
