require './document_uploader'

class DocumentFile < ActiveRecord::Base
  mount_uploader :source, DocumentUploader

  belongs_to :document
end