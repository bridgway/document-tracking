require 'digest/md5'

class Comment < ActiveRecord::Base
  belongs_to :document
  belongs_to :source, :polymorphic => true

  validates :source_id, :presence => true
  validates :body, :presence => true

  def gravatar
    if !@gravatar_url
      email = self.source.email
      hash = Digest::MD5.hexdigest email
      @gravatar_url = "http://www.gravatar.com/avatar/#{hash}"
    end

    @gravatar_url
  end
end