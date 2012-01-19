class Survey < ActiveRecord::Base
  belongs_to :user
  has_many :locations
  has_many :answers
  has_many :ratings
  
  validates_presence_of :name, :question
end
