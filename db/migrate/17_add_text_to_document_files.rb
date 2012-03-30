class AddTextToDocumentFiles < ActiveRecord::Migration
  def change
    add_column :document_files, :text, :text
  end
end