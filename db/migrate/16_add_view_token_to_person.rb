class AddViewTokenToPerson < ActiveRecord::Migration
  def change
    add_column :document_transfers, :view_token, :string
  end
end