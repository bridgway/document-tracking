require 'resque/tasks'

task "resque:setup" => :environment

namespace :app do
  desc "Reset the app!"
  task :reset => [:environment, "db:schema:load"] do
    user = User.create(
      :first_name => "Justin",
      :last_name => "Woodbridge",
      :email => "jwoodbridge@me.com",
      :freshbooks_url => "https://woodbridge.freshbooks.com/api/2.1/xml-in",
      :freshbooks_token => "e4e173dbe0aa2cac2f8349ee0edde949"
    )

    user.password = "justin"
    user.save

    puts "creating test document + data"

    file = DocumentFile.new source: File.open('public/w9.pdf')
    file.save

    doc = Document.new message: "a test"
    doc.recipients << user.people.first
    doc.signee = doc.recipients.first
    doc.files << file
    user.documents << doc

    [
      { name: "Jason Fried", email: "jason@example.com" },
      { name: "Robert Di Niro", email: "robert@example.com" } ,
      { name: "Yukihiro Matsumoto", email: "matz@ruby-lang.org" }
    ].each do |person|
      Person.where(person).first_or_create do |creating|
        creating.user = user
      end
    end

  end
end