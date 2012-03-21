class AddRelationshipsToTables < ActiveRecord::Migration
  def change
    add_column :document_files, :user_id, :integer

    add_column :people, :user_id, :integer
    add_column :people, :document_id, :integer

    create_table :document_transfers do |t|
      t.integer :document_id
      t.integer :file_id
      t.integer :recipient_id

      t.timestamps
    end
  end
end