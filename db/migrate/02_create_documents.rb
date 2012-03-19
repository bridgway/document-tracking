class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.string :recipient
      t.integer :user_id

      t.timestamps
    end
  end
end