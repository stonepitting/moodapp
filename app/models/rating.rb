class Rating < ActiveRecord::Base
  belongs_to :survey
  belongs_to :location
  validates_presence_of :survey, :label, :location

  acts_as_xlsx

end
