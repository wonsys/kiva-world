module Kiva
  class Partner < Kiva::Resource
    include DataMapper::Resource
    
    # Properties
    property :id, Integer, :key => true
    property :loans_posted, Integer
    property :default_rate, Integer
    property :total_amount_raised, Integer
    property :delinquency_rate, Integer
    property :name, String, :length => 255
    property :rating, Integer
    property :status, Enum[:active, :closed, :paused, :pilot]
    property :image_template_id, String, :length => 255
    property :image_id, String, :length => 255
    property :start_date, DateTime
    property :created_at, DateTime
    property :updated_at, DateTime
    
    # Associations
    has n, :loans, :class_name => 'Kiva::Loan'
    has n, :countries, :class_name => 'Kiva::Country'
    
    class << self
      public # PUBLIC class methods
      
      # If force is true forces fetching of all objects (creates the new ones and tries to updates the old ones)
      def update_all!(force=false)
        update_resources(:partners, :all_partners, 'id', force, ['countries'])
      end
      
      def find_countries
        countries = []
        values    = []
        repository(:default).adapter.query("SELECT kiva_countries.iso_code AS country, COUNT(*) AS value FROM kiva_countries
                                            WHERE kiva_countries.iso_code IS NOT NULL AND kiva_countries.iso_code <> ''
                                            GROUP BY kiva_countries.iso_code
                                            ORDER BY value DESC").each do |loan|
          countries << loan.country
          values    << loan.value
        end
        return countries, values
      end
    end # Partner (self)
    
    public # PUBLIC instance methods
    
    def image=(info)
      self.image_template_id = info['template_id']
      self.image_id = info['id']
    end
    
    def description=(info)
      self.description_languages = info['languages']
    end
    
  end # Partner
end # Kiva