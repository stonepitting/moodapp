class Answer < ActiveRecord::Base
  belongs_to :user
  belongs_to :survey
  has_many :votes
  
  has_attached_file :pic, :styles => { :medium => "400x500>", :thumb => "300x200>" }
  
  validates_presence_of :content, :survey_id
end
