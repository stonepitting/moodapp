class CreateVotes < ActiveRecord::Migration
  def self.up
    create_table :votes do |t|
      t.integer :survey_id
      t.integer :answer_id
      t.integer :location_id
      t.string :ip

      t.timestamps
    end
  end

  def self.down
    drop_table :votes
  end
end
