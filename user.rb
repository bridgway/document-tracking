require './freshbooks'

class User < ActiveRecord::Base

  validates :email, :presence => true

  # TODO: Should validate if the credentials are good before the user signs up.
  # Signing up with a non-valid url here explodes the app
  validates :freshbooks_token, :presence => true
  validates :freshbooks_url, :presence => true

  has_many :documents

  after_create do
    f = self.freshbooks_client
    client = JSON.dump f.clients

    self.people = client

    self.save
  end

  def get_people
    JSON.parse(self.people)
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
end