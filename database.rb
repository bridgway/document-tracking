
require 'sequel'
require 'logger'
require './freshbooks'
require 'json'


DB = Sequel.connect('sqlite://database.db')


class User < Sequel::Model
  def after_create
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
    user = User.first(:email => email)
    if user
      user.id
    end
  end
end


if !DB.table_exists?(:users)
  DB.create_table :users do
    primary_key :id

    String :email, :null => false
    String :password_hash, :null => false
    String :freshbooks_token, :null => false
    String :freshbooks_url, :null => false

    Text :people
  end


  User.create(
    :email => "jwoodbridge@me.com",
    :password_hash => "aoeuaoeu",
    :freshbooks_url => "https://woodbridge.freshbooks.com/api/2.1/xml-in",
    :freshbooks_token => "e4e173dbe0aa2cac2f8349ee0edde949"
  )
end

users = DB[:users]