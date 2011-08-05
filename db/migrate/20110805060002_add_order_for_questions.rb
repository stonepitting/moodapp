class AddOrderForQuestions < ActiveRecord::Migration
  def self.up
    add_column :answers, :order, :integer
  end

  def self.down
    remove_column :answers, :order
  end
end
