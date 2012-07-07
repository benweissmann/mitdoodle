class AddKeyAndDescToPoll < ActiveRecord::Migration
  def self.up
    add_column :polls, :key, :string
    add_column :polls, :desc, :text
  end

  def self.down
    remove_column :polls, :desc
    remove_column :polls, :key
  end
end
