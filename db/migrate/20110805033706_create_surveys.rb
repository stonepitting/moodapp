class CreateSurveys < ActiveRecord::Migration
  def self.up
    create_table :surveys do |t|
      t.string :name
      t.string :question
      t.text :description
      t.boolean :enabled, :default => true
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :surveys
  end
end
