require 'gravatar'

class Person < ActiveRecord::Base
  include Gravatar

  belongs_to :user

  has_many :documents, :through => :document_transfers
  has_many :comments, :as => :source
  has_many :tokens

  def is_signee?(document)
    document.signee_id == self.id
  end

  def gravatar
    gravatar_url self.email
  end
end