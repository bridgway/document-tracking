require 'sinatra'
require 'erb'
require 'json'
require 'barista'
require 'sinatra/flash'

require './db/database'
require './document_file'
require './document'
require './user'

class App < Sinatra::Base
  enable :sessions

  register Barista::Integration::Sinatra
  Barista.root = "coffee/"

  register Sinatra::Flash

  set :session_secret, "secret"

  def authenticate!
    if !session[:user_id]
      redirect '/login'
    end
  end

  def current_user
    User.where(id: session[:user_id]).first
  end

  def logged_in?
    session[:user_id] != nil
  end

  get '/' do
    authenticate!
    @user = current_user
    erb :index
  end

  get '/login' do
    if !logged_in?
      erb :login
    else
      redirect '/'
    end
  end

  get '/logout' do
    session[:user_id] = nil
    redirect '/'
  end

  post '/login' do
    user_id = User.authenticate(params[:email])

    if user_id
      flash[:notice] = "You're logged in!"
      session[:user_id] = user_id
      redirect '/'
    else
      flash[:notice] = "Bad password / email :("
      redirect '/login'
    end
  end

  get '/template' do
    erb :template
  end

  get '/show' do
    erb :show
  end

  get '/documents/new' do
    erb :new
  end

  post '/documents/new' do
  end

  post '/upload' do
    puts params

    temp_file = params[:files][0]
    file = DocumentFile.new()
    file.source = temp_file

    if file.save
      attrs = {
        id: file.id,
        url: file.source.url
      }

      return attrs.to_json
    else
      return file.errors.to_json
    end

    # TODO: I'll save this with paperclip.
    # [{
    #   name: 'foo.png',
    #   size: '1',
    #   thumbnail_url: 'http://placehold.it/600x400'
    # }].to_json
  end
end