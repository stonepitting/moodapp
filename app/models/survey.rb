class Survey < ActiveRecord::Base
  belongs_to :user
  has_many :locations
  has_many :answers
  has_many :ratings
  has_many :stack_surveys
  has_many :stacks, :through => :stack_surveys
  
  validates_presence_of :name, :question
end
