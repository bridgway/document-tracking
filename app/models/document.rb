class Document < ActiveRecord::Base
  belongs_to :user

  has_many :document_transfers
  has_many :recipients, :class_name => Person, :through => :document_transfers
  has_many :files, :class_name => DocumentFile, :through => :document_transfers

  validates :message, :presence => true
  validates :file, :presence => true
  validates :recipients, :presence => true

  STATUSES = {
    :unsigned => 0,
    :signed => 1
  }

  READ_STATUSES = STATUSES.invert

  scope :unsigned, where(:status => STATUSES[:unsigned])
  scope :signed, where(:status => STATUSES[:signed])

  class UnkownDocumentStatus < Exception; end

  def status
    raw = read_attribute(:status)
    READ_STATUSES[raw]
  end

  def status=(sym)
    status = STATUSES[sym]

    if !status
      raise UnkownDocumentStatus
    end

    write_attribute(:status, status)
  end

  # Not sure where we're leaning to in terms of one file or multilpe files.
  # For now, just fake it.

  def file
    self.files.first
  end

  def file=(src)
    if !self.files.empty?
      self.files.shift
    end

    self.files.push(src)
  end
end