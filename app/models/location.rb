class Location < ActiveRecord::Base
  belongs_to :user
  belongs_to :survey
  has_many :votes
  
  validates_presence_of :name
end
