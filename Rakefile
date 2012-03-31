require 'active_record'
require 'rake/testtask'
require 'resque/tasks'
require 'bundler'

Bundler.require


# Load up required the required parts of the app for our workers.
task "resque:setup" do
  $ROOT = File.expand_path(File.dirname(__FILE__))

  $LOAD_PATH.unshift $ROOT
  $LOAD_PATH.unshift File.join($ROOT, 'lib')
  $LOAD_PATH.unshift File.join($ROOT, 'app')

  CarrierWave.configure do |config|
    here = File.join(File.dirname(__FILE__))
    config.root = "#{here}/public"
  end

  require_relative 'db/database'
  require 'app/models/document_file'
end

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
    require './app/app'

    ActiveRecord::Base.establish_connection(
      :adapter => "sqlite3",
      :database => "database.db"
    )

    ActiveRecord::Migrator.migrate(
      'db/migrate',
      ENV["VERSION"] ? ENV["VERSION"].to_i : nil
    )
  end

  desc "Seed the database with test data"
  task :seed do
    require './app/app'
    puts "Creating test user..."

    user = User.create(
      :first_name => "Justin",
      :last_name => "Woodbridge",
      :email => "jwoodbridge@me.com",
      :freshbooks_url => "https://woodbridge.freshbooks.com/api/2.1/xml-in",
      :freshbooks_token => "e4e173dbe0aa2cac2f8349ee0edde949"
    )

    puts "creating test document + data"

    file = DocumentFile.new source: File.open('public/w9.pdf')
    file.save

    doc = Document.new message: "a test"
    doc.recipients << user.people.first
    doc.files << file
    doc.save

    user.documents << doc
  end

  desc "Delete the database"
  task :delete do
    if ENV['RACK_ENV'] == 'productino'
      puts "Not going to do that in production."
      exit
    end

    sh "rm database.db"
  end

  desc "Delete the database, remigrate, and seed"
  task :reset => ["delete", "migrate", "seed"]

end

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/test*.rb']
  t.verbose = true
end

task :default => :start