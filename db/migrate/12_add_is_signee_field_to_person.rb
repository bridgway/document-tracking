class AddIsSigneeFieldToPerson < ActiveRecord::Migration
  def change
    add_column :people, :is_signee, :boolean
  end
end