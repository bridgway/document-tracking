require 'resque/server'

Documents::Application.routes.draw do
  root :to => 'documents#index'

  resources :documents

  get '/login' => 'sessions#new', :as => :login
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy', :as => :logout

  mount Resque::Server.new, :at => "/resque"
end
