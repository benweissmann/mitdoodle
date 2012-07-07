class AddShortLinkToPoll < ActiveRecord::Migration
  def self.up
    add_column :polls, :short_link, :string
  end

  def self.down
    remove_column :polls, :short_link
  end
end
