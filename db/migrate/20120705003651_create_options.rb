class CreateOptions < ActiveRecord::Migration
  def self.up
    create_table :options do |t|
      t.integer :poll_id
      t.string :label

      t.timestamps
    end
  end

  def self.down
    drop_table :options
  end
end
