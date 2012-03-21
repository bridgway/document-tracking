class RemoveUnecessaryDocumentColumns < ActiveRecord::Migration
  def change
    remove_column :documents, :recipient
    remove_column :document_files, :document_id
    remove_column :people, :document_id
  end
end