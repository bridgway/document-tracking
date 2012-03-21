class AddMessageToDocument < ActiveRecord::Migration
  def change
    add_column :documents, :message, :text
  end
end