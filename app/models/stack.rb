class Stack < ActiveRecord::Base
  belongs_to :user
  has_many :stack_surveys
  has_many :surveys, :through => :stack_surveys
end
