module Kiva
  class Lender < Kiva::Resource
    include DataMapper::Resource
    
    # Properties
    property :uid, String, :key => true, :length => 255
    property :lender_id, String, :length => 255
    property :name, String, :length => 255
    property :loan_because, Text, :lazy => false
    property :whereabouts, Text, :lazy => false
    property :country_code, String, :length => 255
    property :occupation, String, :length => 255
    property :occupational_info, Text, :lazy => false
    property :personal_url, String, :length => 255
    property :loan_count, Integer
    property :invitee_count, Integer
    property :image_template_id, String
    property :image_id, String
    property :member_since, DateTime
    property :created_at, DateTime
    property :updated_at, DateTime
    
    # Associations
    # has n, :loans, :class_name => 'Kiva::Loan'

    class << self
      public # PUBLIC class methods

      def get_random(limit=100)
        rand(limit)
      end
      
      # If force is true forces fetching of all objects (creates the new ones and tries to updates the old ones)
      def update_all!(force=false)
        import!
        Kiva::Lender.all.each do |lender|
          update_resources(:lenders, :lender, 'uid', force, nil, lender.uid)
        end
      end
      
      private # PRIVATE class methods
      
      def import!
        Kiva::Loan.all.each do |loan|
          update_resources(:lenders, :lenders, 'uid', false, nil, loan.id)
        end
      end
      
      def rand(limit=100)
        self.find_by_sql("SELECT * FROM kiva_lenders ORDER BY RAND() LIMIT #{limit}")
      end
    end # Lender (self)

    public # PUBLIC instance methods
    
    def because
      self.loan_because.blank? ? '' : (self.loan_because[0].chr.downcase + self.loan_because[1..-1])
    end
    
    def from
      self.member_since.formatted(:international => :it, :months => :long, :separator => ' ')
    end
    
    def image=(info)
      self.image_template_id = info['template_id']
      self.image_id = info['id']
    end
    
    def image_url
      id = self.image_id || 0
      "http://kiva.org/img/w180h180/#{id}.jpg"
    end
    
    def job
      self.occupational_info.blank? ? (self.occupation.blank? ? '' : "I am a #{self.occupation.downcase}") : self.occupational_info
    end
    
    def personal_url=(original_url)
      url = original_url.blank? ? '' : ((/\Ahttp:\/\// === url) ? url : "http://#{url}")
      attribute_set(:personal_url, url)
    end
    
    def to_hash(original=false)
      if original
        {:uid           => self.uid,
         :lender_id     => self.lender_id,
         :name          => self.name,
         :loan_because  => self.loan_because,
         :whereabouts   => self.whereabouts,
         :country_code  => self.country_code,
         :occupation    => self.occupation,
         :occupational_info => self.occupational_info,
         :personal_url  => self.personal_url,
         :loan_count    => self.loan_count,
         :invitee_count => self.invitee_count,
         :image         => {:id => self.image_id, :template_id => self.image_template_id},
         :member_since  => self.member_since}
      else
        {:name          => self.name,
         :because       => self.because,
         :where         => self.where,
         :from          => self.from,
         :job           => self.job,
         :image_url     => self.image_url,
         :personal_url  => self.personal_url,
         :loan_count    => self.loan_count,
         :url           => self.url}
      end
    end
    
    def to_json(original=false)
      self.to_hash(original).to_json
    end
    
    def url
      "http://www.kiva.org/lender/#{lender_id}"
    end
    
    def where
      if self.country_code.blank? && self.whereabouts.blank?
        ''
      elsif self.country_code.blank?
        self.whereabouts
      elsif self.whereabouts.blank?
        self.country_code
      else
        "#{self.whereabouts} (#{self.country_code})"
      end
    end
  end # Lender
end # Kiva