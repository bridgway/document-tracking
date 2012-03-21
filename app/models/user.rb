require 'freshbooks'

class User < ActiveRecord::Base

  validates :email, :presence => true

  # TODO: Should validate if the credentials are good before the user signs up.
  # Signing up with a non-valid url here explodes the app
  validates :freshbooks_token, :presence => true
  validates :freshbooks_url, :presence => true

  has_many :documents
  has_many :people

  after_create do
    f = self.freshbooks_client

    f.clients.each do |client|
      self.people << Person.create(:email => client[:name], :name => client[:name])
    end

    self.save
  end

  def get_people
    i = 1
    JSON.parse(self.people).map do |hash|
      hash.merge! :id => i
      i += 1
      hash
    end
  end

  def freshbooks_client
    @freshbooks_client ||= Freshbooks.new self.freshbooks_url, self.freshbooks_token
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