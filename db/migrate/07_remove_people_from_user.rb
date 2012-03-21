class RemovePeopleFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :people
  end
end