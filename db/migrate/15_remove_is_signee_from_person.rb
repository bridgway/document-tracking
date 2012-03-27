class RemoveIsSigneeFromPerson < ActiveRecord::Migration
  def change
    remove_column :people, :is_signee
  end
end