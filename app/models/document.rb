class Document < ActiveRecord::Base
  belongs_to :user

  has_many :document_transfers
  has_many :recipients, :class_name => Person, :through => :document_transfers
  has_many :files, :class_name => DocumentFile, :through => :document_transfers

  validates :message, :presence => true
  validates :files, :presence => true
  validates :recipients, :presence => true
end