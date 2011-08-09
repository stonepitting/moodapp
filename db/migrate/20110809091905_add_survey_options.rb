class AddSurveyOptions < ActiveRecord::Migration
  def self.up
    add_column :surveys, :display_stats, :boolean, :default => true
    add_column :surveys, :votes_before_stats, :integer, :default => 10
    add_column :surveys, :stats_default_history, :integer, :default => 7
  end

  def self.down
    remove_column :surveys, :display_stats
    remove_column :surveys, :votes_before_stats
    remove_column :surveys, :stats_default_history
  end
end
