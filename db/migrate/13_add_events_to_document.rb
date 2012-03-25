class AddEventsToDocument < ActiveRecord::Migration
  def change
    add_column :documents, :events, :text, :default => [].to_json
  end
end