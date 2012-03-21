class AddStatusToDocument < ActiveRecord::Migration
  def change
    add_column :documents, :status, :integer, :default => 0
  end
end