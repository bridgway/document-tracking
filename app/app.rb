require 'sinatra'
require 'erb'

require 'json'
require 'barista'
require 'sinatra/flash'

$: << File.expand_path("./lib")
$: << File.expand_path(File.dirname(__FILE__))

require 'environment'
require './db/database'
require 'models/document_file'
require 'models/person'
require 'models/document'
require 'models/user'
require 'models/document_transfer'

class App < Sinatra::Base
  include Environment

  enable :sessions

  register Barista::Integration::Sinatra
  Barista.root = "coffee/"

  register Sinatra::Flash

  set :session_secret, "secret"

  root = File.dirname(File.expand_path(__FILE__))
  set :public_folder, "#{root}/../../public"
  set :views, "#{root}/views"

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

  def json(content)
    content_type :json
    content.to_json
  end

  post '/documents/new' do
    # TODO: Scope the queries to the current_user only.

    doc = Document.new
    json = JSON.parse params[:document], symbolize_names: true

    json[:files].each do |file|
      doc.files << DocumentFile.find(file[:id])
    end

    json[:recipients].each do |recipient|
      doc.recipients << Person.find(recipient[:id])
    end

    doc.message = json[:message]

    if doc.save
      json doc
    else
      json doc.errors
    end
  end

  post '/upload' do
    puts params

    temp_file = params[:files][0]
    file = DocumentFile.new
    file.source = temp_file

    if file.save
      attrs = {
        id: file.id,
        url: file.source.thumb.url
      }

      json attrs
    else
      json "aoeu"
    end
  end
end