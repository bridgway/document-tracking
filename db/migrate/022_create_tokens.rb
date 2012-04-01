class CreateTokens < ActiveRecord::Migration
  def change
    create_table :tokens do |t|
      t.integer :person_id
      t.integer :document_id

      t.string :code

      t.timestamps
    end
  end
end
