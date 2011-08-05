class CreateAnswers < ActiveRecord::Migration
  def self.up
    create_table :answers do |t|
      t.integer :survey_id
      t.boolean :as_image
      t.string :content
      t.string :pic_file_name
      t.string :pic_content_type
      t.integer :pic_file_size
      t.datetime :pic_updated_at
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :answers
  end
end
