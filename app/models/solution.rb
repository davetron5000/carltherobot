class Solution < ActiveRecord::Base
  belongs_to :player
  serialize :code, Array
end
