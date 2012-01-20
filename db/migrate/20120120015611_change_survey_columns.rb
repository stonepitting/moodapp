class ChangeSurveyColumns < ActiveRecord::Migration
  def self.up
    add_column :surveys, :scale_type, :string, :default => 'hand'
  end

  def self.down
    remove_column :surveys, :scale_type
  end
end
