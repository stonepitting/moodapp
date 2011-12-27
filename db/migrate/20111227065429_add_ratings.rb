class AddRatings < ActiveRecord::Migration
  def self.up
    create_table :ratings do |t|
      t.integer :survey_id
      t.string :label
      t.integer :location_id
      t.string :ip

      t.timestamps
    end
  end

  def self.down
    drop_table :ratings
  end
end
