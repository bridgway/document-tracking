class Comment < ActiveRecord::Base
  belongs_to :source, :polymorphic => true

  validates :source_id, :presence => true
  validates :body, :presence => true
end