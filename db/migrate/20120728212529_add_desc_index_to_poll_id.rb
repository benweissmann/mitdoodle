class AddDescIndexToPollId < ActiveRecord::Migration
  def self.up
    add_index :polls, :id, :order => {:id => :desc}, :name => :poll_id_desc
  end

  def self.down
    remove_index :polls, :name => :poll_id_desc
  end
end
