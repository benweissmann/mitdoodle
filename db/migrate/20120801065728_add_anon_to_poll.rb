class AddAnonToPoll < ActiveRecord::Migration
  def self.up
    add_column :polls, :anon, :boolean, :null => false, :default => false
  end

  def self.down
    remove_column :polls, :anon
  end
end
