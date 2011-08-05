class Survey < ActiveRecord::Base
  belongs_to :user
  has_many :locations
  has_many :answers
  
  validates_presence_of :name, :question
end
