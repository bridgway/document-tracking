require 'peoplekit/peoplekit'

class User < ActiveRecord::Base

  validates :email, :presence => true

  # TODO: Should validate if the credentials are good before the user signs up.
  # Signing up with a non-valid url here explodes the app
  validates :freshbooks_token, :presence => true
  validates :freshbooks_url, :presence => true

  has_many :documents
  has_many :files, :class_name => DocumentFile
  has_many :people
  has_many :comments, :as => :source

  has_many :document_transfers, :through => :documents

  after_create do
    f = self.freshbooks_client

    f.clients.each do |client|
      self.people << Person.create(:email => client[:email], :name => client[:name])
    end

    self.save
  end

  def freshbooks_client
    config = { :url => self.freshbooks_url, :token => self.freshbooks_token }

    @freshbooks_client ||= PeopleKit.connect :freshbooks, config
  end

  def people_json
    self.people.map { |person| { id: person.id, email: person.email, name: person.name } }.to_json
  end

  def unsigned_documents
    self.documents.unsigned
  end

  def signed_documents
    self.documents.signed
  end

  def name
    [self.first_name, " ", self.last_name].join
  end

  def self.authenticate(email, password=nil)
    user = User.find_by_email(email)
    if user
      user.id
    end
  end

  def self.create_admin!
    if App.development?
      User.create(
        :email => "jwoodbridge@me.com",
        :freshbooks_token => "e4e173dbe0aa2cac2f8349ee0edde949",
        :freshbooks_url => "https://woodbridge.freshbooks.com/api/2.1/xml-in",
        :password_hash => "aoeuaoeu"
      )
    end
  end
end