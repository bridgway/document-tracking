require 'resque/server'

Documents::Application.routes.draw do
  root :to => 'users#show'

  mount Resque::Server.new, :at => "/resque"

  get '/login' => 'sessions#new', :as => :login
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy', :as => :logout

  resources :users, :only => [:show], :path => ''  do
    post '/clear_activity' => 'users#clear_activity', :as => :clear_activity

    resources :documents do
      resources :comments, :shallow => true, :only => [:create, :destroy]
    end

    resources :document_transfers
    get '/:id/view' => 'documents#show', :as => :public_document_page

    resources :people

    # Importing
    match '/import/freshbooks' => 'import#freshbooks', :as => :freshbooks_import
  end

  resources :users
end
