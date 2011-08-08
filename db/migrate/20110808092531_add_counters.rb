class AddCounters < ActiveRecord::Migration
  def self.up
    add_column :answers, :votes_count, :integer, :default => 0
    add_column :surveys, :votes_count, :integer, :default => 0
    add_column :locations, :votes_count, :integer, :default => 0
  end

  def self.down
    remove_column :answers, :votes_count
    remove_column :surveys, :votes_count
    remove_column :locations, :votes_count
  end
end
