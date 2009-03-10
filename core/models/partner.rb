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
        update_resource(:partners, :all_partners, 'id', force, ['countries']) do |partner, countries|
          if countries.any?
            partner_countries = partner.countries
            partner_countries.destroy! if partner_countries.any?
            countries.each { |country| partner.countries << partner.countries.build(country)}
          end
        end
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