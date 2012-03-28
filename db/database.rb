require 'active_record'
require 'uri'
require 'sqlite3'
require 'logger'

require 'carrierwave'
require 'carrierwave/orm/activerecord'


ActiveRecord::Base.establish_connection(
  :adapter  => 'sqlite3',
  :database => 'database.db',
  :encoding => 'utf8'
)

ActiveRecord::Base.logger = Logger.new(STDOUT)