module Kiva
  class Lender
    include DataMapper::Resource

    property :uid, String, :key => true
    property :lender_id, String
    property :name, String
    property :loan_because, Text, :lazy => false
    property :whereabouts, Text, :lazy => false
    property :country_code, String
    property :occupation, String
    property :occupational_info, Text, :lazy => false
    property :personal_url, String
    property :loan_count, Integer
    property :invitee_count, Integer
    property :image_template_id, String
    property :image_id, String
    property :member_since, DateTime
    property :created_at, DateTime
    property :updated_at, DateTime

    class << self
      public # PUBLIC class methods

      def get_random(limit=100)
        rand(limit)
      end

      private # PRIVATE class methods

      def rand(limit=100)
        self.find_by_sql("SELECT * FROM kiva_lenders ORDER BY RAND() LIMIT #{limit}")
      end
    end # Lender (self)

    public # PUBLIC instance methods

    def image=(info)
      self.image_template_id = info['template_id']
      self.image_id = info['id']
    end

    def to_hash
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
    end

    def to_json
      self.to_hash.to_json
    end
  end # Lender
end # Kiva