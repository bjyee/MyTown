class Town < ActiveRecord::Base

	has_many :attractions, :dependent => :destroy

	STATES_LIST = [['Alabama', 'AL'],['Alaska', 'AK'],['Arizona', 'AZ'],['Arkansas', 'AR'],['California', 'CA'],['Colorado', 'CO'],['Connectict', 'CT'],['Delaware', 'DE'],['District of Columbia ', 'DC'],['Florida', 'FL'],['Georgia', 'GA'],['Hawaii', 'HI'],['Idaho', 'ID'],['Illinois', 'IL'],['Indiana', 'IN'],['Iowa', 'IA'],['Kansas', 'KS'],['Kentucky', 'KY'],['Louisiana', 'LA'],['Maine', 'ME'],['Maryland', 'MD'],['Massachusetts', 'MA'],['Michigan', 'MI'],['Minnesota', 'MN'],['Mississippi', 'MS'],['Missouri', 'MO'],['Montana', 'MT'],['Nebraska', 'NE'],['Nevada', 'NV'],['New Hampshire', 'NH'],['New Jersey', 'NJ'],['New Mexico', 'NM'],['New York', 'NY'],['North Carolina','NC'],['North Dakota', 'ND'],['Ohio', 'OH'],['Oklahoma', 'OK'],['Oregon', 'OR'],['Pennsylvania', 'PA'],['Rhode Island', 'RI'],['South Carolina', 'SC'],['South Dakota', 'SD'],['Tennessee', 'TN'],['Texas', 'TX'],['Utah', 'UT'],['Vermont', 'VT'],['Virginia', 'VA'],['Washington', 'WA'],['West Virginia', 'WV'],['Wisconsin ', 'WI'],['Wyoming', 'WY']]

	scope :all, order('name')
	
	accepts_nested_attributes_for :attractions, :reject_if => lambda { |attraction| attraction[:name].blank? }
	
	before_save :find_town_coordinates
	
	def create_map_link(zoom=12,width=800,height=800)
		markers = ""; i = 1
		self.attractions.all.each do |attr|
			markers += "&markers=color:red%7Ccolor:red%7Clabel:#{i}%7C#{attr.lat},#{attr.lon}"
			i += 1
		end
		map = "http://maps.google.com/maps/api/staticmap?center=#{lat},#{lon}&zoom=#{zoom}&size=#{width}x#{height}&maptype=#{markers}&sensor=false"
	end
	
	private
	
	def find_town_coordinates
		coord = Geokit::Geocoders::GoogleGeocoder.geocode "#{name}, #{state}"
		if coord.success
			self.lat, self.lon = coord.ll.split(',')
		else
			errors.add_to_base("Error with geocoding")
		end
	end
	
end
