require 'resque/server'

Documents::Application.routes.draw do
  root :to => 'users#show'

  resources :users, :path => '' do
    resources :documents
    resources :document_transfers

    get '/:id/view' => 'documents#show', :as => :public_document_page
  end

  get '/login' => 'sessions#new', :as => :login
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy', :as => :logout

  mount Resque::Server.new, :at => "/resque"
end
