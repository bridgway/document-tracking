class CreateDocumentFiles < ActiveRecord::Migration

  def change
    create_table :document_files do |t|
      t.integer :document_id
      t.string :source

      t.timestamps
    end
  end
end