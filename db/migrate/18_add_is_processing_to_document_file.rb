class AddIsProcessingToDocumentFile < ActiveRecord::Migration
  def change
    add_column :document_files, :is_processing, :boolean
  end
end