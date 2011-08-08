class Vote < ActiveRecord::Base
  belongs_to :survey
  belongs_to :answer
  belongs_to :location
  validates_presence_of :survey, :answer, :location
end
