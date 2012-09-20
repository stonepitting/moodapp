class CreateStackSurveys < ActiveRecord::Migration
  def self.up
    create_table :stack_surveys do |t|
      t.references :stack
      t.references :survey

      t.timestamps
    end
  end

  def self.down
    drop_table :stack_surveys
  end
end
