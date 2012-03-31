require 'rubygems'
require 'bundler'

Bundler.require

require './app/app'
require 'resque/server'

run Rack::URLMap.new \
  "/"       => App.new,
  "/resque" => Resque::Server.new