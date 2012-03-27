require 'sinatra'
require 'erb'

require 'json'
require 'barista'
require 'sinatra/flash'

$: << File.expand_path("./lib")
$: << File.expand_path(File.dirname(__FILE__))

require 'helpers'

require 'peoplekit/peoplekit'

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

  def self.root
    File.expand_path '.'
  end

  app_folder_root = File.dirname(File.expand_path(__FILE__))
  set :public_folder, "#{app_folder_root}/../../public"
  set :views, "#{app_folder_root}/views"

  CarrierWave.configure do |config|
    if !App.production?
      config.root = App.root + "/public"
    end
  end

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

  def partial(name, locals = {})
    erb name.to_sym, layout: false, locals: locals
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

    def current_user
      # TODO: Cache this in a an instance variable
      User.where(id: session[:user_id]).first
    end
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


  #
  #  Document Routes


  post '/documents/new' do
    file = DocumentFile.new(:user_id => current_user.id, :source => params[:file])
    doc = Document.new message: params[:message]

    doc.file = file
    doc.user = current_user

    signee = Person.find_by_name params[:to]

    doc.signee = signee
    doc.recipients << signee

    params[:cc].split(",").map(&:strip).each do |name|
      doc.recipients << Person.find_by_name(name)
    end

    doc.save
  end

  post '/upload' do
    temp_file = params[:file]
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

      render_view "documents/show"
    else
      # 404 it
    end
  end


  #
  #  Comment Routes
  #

  # This shit is why people hate active record.
  def find_source(hash)
    hash.each do |name, value|
      if name =~ /(user|person)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end

  get '/test' do
    puts partial "comments/comment", :comment => Comment.last
    "aoeu"
  end

  post '/comments' do
    source = find_source params[:comment]
    comment = source.comments.build ({
      source: source,
      document_id: params[:comment][:document_id],
      body: params[:comment][:body],
    })

    if comment.save
      return partial "comments/comment", :comment => comment
    else
      json comment.errors
    end
  end


  #
  #  Misc Routes
  #


  not_found do
    redirect '/'
  end
end
