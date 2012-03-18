desc "Start development server"
task :start do
  sh "shotgun config.ru"
end

desc "Boot up IRB with our code"
task :console do
  sh "irb -rubygems -r ./app"
end

task :default => :start