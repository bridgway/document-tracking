require 'document_uploader'

class DocumentFile < ActiveRecord::Base
  mount_uploader :source, DocumentUploader

  has_many :documents, :through => :document_transfers
end