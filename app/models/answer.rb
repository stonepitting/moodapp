class Answer < ActiveRecord::Base
  belongs_to :user
  belongs_to :survey
  
  has_attached_file :pic, :styles => { :medium => "300x300>", :thumb => "100x100>" }
  
  validates_presence_of :content, :survey_id
end
