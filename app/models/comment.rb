require 'digest/md5'
require 'gravatar'

class Comment < ActiveRecord::Base
  include Gravatar

  belongs_to :document
  belongs_to :source, :polymorphic => true

  validates :source_id, :presence => true
  validates :body, :presence => true
end