class Solution < ActiveRecord::Base
  belongs_to :player
  belongs_to :level
  serialize :code, Array
end
