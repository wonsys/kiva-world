module Kiva
  class Country
    include DataMapper::Resource
    
    # Properties
    property :id, Serial
    property :iso_code, String, :index => :partner_country
    property :partner_id, Integer
    property :name, String, :lenght => 255, :index => :partner_country
    property :region, String, :lenght => 255
    property :location_geo_type, String
    property :location_geo_level, String
    property :location_geo_lat, String
    property :location_geo_lng, String
    property :created_at, DateTime
    property :updated_at, DateTime
    
    # Associations
    belongs_to :partners, :class_name => 'Kiva::Partner'
    
    public # PUBLIC instance methods
    
    def location=(info)
      self.location_geo_type = info['geo']['type']
      self.location_geo_level = info['geo']['level']
      self.location_geo_lat, self.location_geo_lng = get_lat_lng(info['geo']['pairs'])
    end
    
    private # PRIVATE instance methods
    
    def get_lat_lng(geo)
      return *geo.deserialize(' ')
    end
  end # Country
end # Kiva