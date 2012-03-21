class DocumentTransfer < ActiveRecord::Base
  belongs_to :document
  belongs_to :file, :class_name => DocumentFile
  belongs_to :recipient, :class_name => Person
end