class Attraction < ActiveRecord::Base

	belongs_to :town
	
	scope :all, order('name')
	
	before_save :find_attraction_coordinates
	
	def create_map_link(zoom=13,width=800,height=800)
		markers = ""; i = 1
		self.attractions.all.each do |attr|
			markers += "&markers=color:red%7Ccolor:red%7Clabel:#{i}%7C#{attr.lat},#{attr.lon}"
			i += 1
		end
		map = "http://maps.google.com/maps/api/staticmap?center=#{lat},#{lon}&zoom=#{zoom}&size=#{width}x#{height}&maptype=#{markers}&sensor=false"
	end
	
	private
  
    def find_attraction_coordinates
      str = self.street
      town = self.town.name
      st = self.town.state
      coord = Geokit::Geocoders::GoogleGeocoder.geocode "#{str}, #{town}, #{st}"
      if coord.success
  	    self.lat, self.lon = coord.ll.split(',')
  	  else 
  	    errors.add_to_base("Error with geocoding")
  	  end
    end
end
