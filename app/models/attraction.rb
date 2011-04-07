class Attraction < ActiveRecord::Base

	belongs_to :town
	
	scope :all, order('name')
end
