class Token < ActiveRecord::Base
  belongs_to :person

  before_create do
    self.code = SecureRandom.hex.encode('utf-8')
  end
end
