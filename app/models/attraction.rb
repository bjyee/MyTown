class Attraction < ActiveRecord::Base

	belongs_to :towns
	
	scope :all, order('name')
end
