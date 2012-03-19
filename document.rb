class Document < ActiveRecord::Base
  belongs_to :user
  has_one :document_file
end