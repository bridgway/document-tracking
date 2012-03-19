class Document < ActiveRecord::Base
  belongs_to :user

  has_many :document_files
end