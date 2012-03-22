require 'sinatra'
require 'erb'

require 'json'
require 'barista'
require 'sinatra/flash'

$: << File.expand_path("./lib")
$: << File.expand_path(File.dirname(__FILE__))

require 'helpers'

require 'environment'
require './db/database'
require 'models/document_file'
require 'models/person'
require 'models/document'
require 'models/user'
require 'models/document_transfer'
require 'models/comment'

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

  def render_view(name, args = {})
    path = name.to_sym
    if args.has_key?(:layout)
      args[:layout] = ("layouts/" + args[:layout]).to_sym
    end
    erb path, args
  end

  def authenticate!
    if !session[:user_id]
      redirect '/login'
    end
  end

  def current_user
    # TODO: Cache this in a an instance variable
    User.where(id: session[:user_id]).first
  end

  def logged_in?
    session[:user_id] != nil
  end

  helpers do
    include Helpers
  end

  get '/' do
    authenticate!
    @user = current_user
    @unsigned = @user.unsigned_documents
    @signed = @user.signed_documents

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
    doc = Document.new
    json = JSON.parse params[:document], symbolize_names: true

    json[:files].each do |file|
      doc.files << current_user.files.find(file[:id])
    end

    json[:recipients].each do |recipient|
      doc.recipients << current_user.people.find(recipient[:id])
    end

    doc.message = json[:message]

    if doc.save
      json doc
    else
      json doc.errors
    end
  end

  post '/upload' do
    temp_file = params[:files][0]
    file = DocumentFile.new(:user_id => current_user.id)
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

  get '/documents/:id' do
    if params[:id].match /(\d*)(?:-)(.*)?/
      id = $1
      slug = $2
      @doc = current_user.documents.where(:id => id).first

      render_view "documents/new"
    else
      # 404 it
    end
  end

  not_found do
    redirect '/'
  end
end