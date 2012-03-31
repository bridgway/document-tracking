namespace :app do
  desc "Reset the app!"
  task :reset => :environment do
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
end