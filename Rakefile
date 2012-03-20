require 'active_record'
require './app/app'

desc "Start development server"
task :start do
  sh "shotgun config.ru"
end

desc "Boot up IRB with our code"
task :console do
  sh "irb -rubygems -r ./app/app"
end

namespace :db do
  desc "Migrate the database up to the latest version."
  task :migrate do
    ActiveRecord::Base.establish_connection(
      :adapter => "sqlite3",
      :database => "database.db"
    )

    ActiveRecord::Migrator.migrate(
      'db/migrate',
      ENV["VERSION"] ? ENV["VERSION"].to_i : nil
    )
  end
end

desc "Seed the database with test data"
task :seed do
  require './db/database'
  puts "Creating test user..."
  User.create(
    :email => "jwoodbridge@me.com",
    :freshbooks_url => "https://woodbridge.freshbooks.com/api/2.1/xml-in",
    :freshbooks_token => "e4e173dbe0aa2cac2f8349ee0edde949"
  )
end

task :default => :start
