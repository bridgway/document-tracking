class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_hash

      t.string :freshbooks_url
      t.string :freshbooks_token

      t.text :people

      t.timestamps
    end
  end
end