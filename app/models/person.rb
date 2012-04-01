class Person < ActiveRecord::Base
  belongs_to :user

  has_many :documents, :through => :document_transfers
  has_many :comments, :as => :source
  has_many :tokens
end