class AddScaleChoiceToSurvey < ActiveRecord::Migration
  def self.up
    add_column :surveys, :scale_size, :integer, :default => 5
  end

  def self.down
    remove_colum :surveys, :scale_type
  end
end
