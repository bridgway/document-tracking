require 'pathname'

class Document < ActiveRecord::Base
  serialize :events, JSON

  belongs_to :user

  has_many :document_transfers, limit: 1

  has_many :recipients, :class_name => Person, :through => :document_transfers

  # TODO: Might be able to replace my custom file accessors by adding :limit => 1
  # http://stackoverflow.com/questions/1480631/has-one-and-has-many-in-same-model-how-does-rails-track-them

  has_many :files, :class_name => DocumentFile, :through => :document_transfers
  has_many :comments

  validates :message, :presence => true
  validates :file, :presence => true
  validates :recipients, :presence => true

  WRITE_STATUSES = {
    :unsigned => 0,
    :signed => 1
  }

  READ_STATUSES = WRITE_STATUSES.invert

  scope :unsigned, where(:status => WRITE_STATUSES[:unsigned])
  scope :signed, where(:status => WRITE_STATUSES[:signed])

  before_create :add_creation_event

  # def to_param
  #   [self.id.to_s, self.filename.downcase.gsub(' ', '-')].join('-')
  # end

  class UnkownDocumentStatus < Exception; end

  def status
    raw = read_attribute(:status)
    READ_STATUSES[raw]
  end

  def status=(sym)
    status = WRITE_STATUSES[sym]

    if !status
      raise UnkownDocumentStatus
    end

    write_attribute(:status, status)
  end

  def slug
    if !@slug

      # kinda awkward.  Basically, get the extension name, and then pass that to basename with the full filename.
      # It returns just the file name.
      # "test.pdf" => "test"

      extennsionless = File.basename self.filename, Pathname.new(self.filename).extname
      @slug = [self.id, '-', extennsionless.downcase.gsub(' ', '-')].join
    end

    @slug
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

  def filename
    File.basename self.file.source.url
  end

  def signee
    self.recipients.where(:id => self.signee_id).first
  end

  def signee=(person)
    # probably should validate if the person is a part of our recipients.
    self.update_attributes :signee_id => person.id
  end

  # return the cc'ed recipients.
  def copied
    self.recipients.select { |r| r.id != self.signee.id }
  end

  def add_creation_event
    self.events << {
      :timestamp => self.created_at,
      :text => "Document was sent.",
      :type => :creation
    }
  end

  def transfer
    self.document_transfers.first
  end
end