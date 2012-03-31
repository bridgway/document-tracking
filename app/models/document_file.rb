require 'document_uploader'
require 'carrierwave'
require 'backgrounder/orm/activerecord'

class DocumentFile < ActiveRecord::Base
  mount_uploader :source, DocumentUploader

  process_in_background :source

  belongs_to :user
  has_many :documents, :through => :document_transfers
end