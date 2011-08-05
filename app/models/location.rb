class Location < ActiveRecord::Base
  belongs_to :user
  belongs_to :survey
  
  validates_presence_of :name
end
