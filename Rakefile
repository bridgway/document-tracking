require 'logger'
require 'active_record'
require 'fileutils'

require 'rake/testtask'
require 'uri'

SPEC = URI.parse(ENV['DATABASE_URL'] || 'postgres://localhost/thoughts')

def connect!
  ActiveRecord::Base.establish_connection(
    :adapter  => 'postgresql',
    :host     => SPEC.host,
    :username => SPEC.user,
    :password => SPEC.password,
    :database => SPEC.path[1..-1],
    :encoding => 'utf8'
  )
end


task :connect do
  connect!

  ActiveRecord::Base.logger = Logger.new(STDOUT)
  ActiveRecord::Base.logger.level =2
end

namespace :db  do
  desc "migrate your database"
  task :migrate => :connect do
    ActiveRecord::Migrator.migrate(
      'db/migrate',
      ENV["VERSION"] ? ENV["VERSION"].to_i : nil
    )
  end

  desc "create an ActiveRecord migration in ./db/migrate"
  task :create_migration => :connect do
    name = ENV['NAME']
    abort("no NAME specified. use `rake db:create_migration NAME=create_users`") if !name

    migrations_dir = File.join("db", "migrate")
    version = ENV["VERSION"] || Time.now.utc.strftime("%Y%m%d%H%M%S")
    filename = "#{version}_#{name}.rb"
    migration_name = name.gsub(/_(.)/) { $1.upcase }.gsub(/^(.)/) { $1.upcase }

    FileUtils.mkdir_p(migrations_dir)

    open(File.join(migrations_dir, filename), 'w') do |f|
      f << (<<-EOS).gsub("      ", "")
      class #{migration_name} < ActiveRecord::Migration
        def self.up
        end

        def self.down
        end
      end
      EOS
    end
  end

  desc "Drop the database, recreate it, and inscribe the latest schema"
  task :rebirth do
    `dropdb thoughts`
    `createdb thoughts`
    connect!
    Rake::Task['db:migrate'].execute
  end
end

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/*_test.rb']
  t.verbose = true
end

desc "Boot up IRB with our code"
task :console do
  sh "irb -rubygems -r "
end