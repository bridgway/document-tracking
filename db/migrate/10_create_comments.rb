class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :source_id
      t.integer :document_id
      t.string :source_type

      t.text :body

      t.timestamps
    end
  end
end