class AddSigneeIdToDocument < ActiveRecord::Migration
  def change
    add_column :documents, :signee_id, :integer
  end
end