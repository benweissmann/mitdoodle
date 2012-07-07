class AddIndexes < ActiveRecord::Migration
  def self.up
    add_index :options, :poll_id
    add_index :polls,   :user_id
    add_index :polls,   :key
    add_index :votes,   :option_id
    add_index :votes,   :user_id
  end

  def self.down
    remove_index :options, :column => :poll_id
    remove_index :polls,   :column => :user_id
    remove_index :polls,   :column => :key
    remove_index :votes,   :column => :option_id
    remove_index :votes,   :column => :user_id
  end
end
