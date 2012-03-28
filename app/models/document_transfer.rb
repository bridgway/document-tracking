require 'securerandom'

class DocumentTransfer < ActiveRecord::Base
  belongs_to :document
  belongs_to :file, :class_name => DocumentFile
  belongs_to :recipient, :class_name => Person

  before_create :generate_view_token

  def generate_view_token
    self.view_token  = SecureRandom.hex.encode('utf-8')
  end
end