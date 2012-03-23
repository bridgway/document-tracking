class Person < ActiveRecord::Base
  belongs_to :user

  scope :signee, where(:is_signee => true)

  has_many :documents, :through => :document_transfers
  has_many :comments, :as => :source
end