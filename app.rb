require 'sinatra'
require 'erb'
require 'json'
require 'barista'

class App < Sinatra::Base
  register Barista::Integration::Sinatra

  Barista.root = "coffee/"

  get '/' do
    erb :index
  end

  get '/template' do
    erb :template
  end

  post '/upload' do
    # TODO: I'll save this with paperclip.
    [{
      name: 'foo.png',
      size: '1',
      thumbnail_url: 'http://placehold.it/600x400'
    }].to_json
  end
end