class ChangeIsProcessingToSourceProcessing < ActiveRecord::Migration
  def change
    rename_column :document_files, :is_processing, :source_processing
  end
end