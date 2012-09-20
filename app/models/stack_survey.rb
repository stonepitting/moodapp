class StackSurvey < ActiveRecord::Base
  belongs_to :stack
  belongs_to :survey
end
