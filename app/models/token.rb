class Token < ActiveRecord::Base
  belongs_to :person
  belongs_to :document

  before_create do
    self.code = SecureRandom.hex.encode('utf-8')
  end
end
