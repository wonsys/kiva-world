module Kiva
  class Journal
    include DataMapper::Resource
    
    # Properties
    property :id, String, :key => true
    property :borrower_count, Integer
    property :status, Enum[:fundraising, :funded, :in_repayment, :paid, :defaulted, :refunded]
    property :name, String
    property :posted_date, DateTime
    property :activity, String
    property :description_languages, String
    property :partner_id, Integer
    property :use, Text
    property :loan_amount, Integer
    property :funded_amount, Integer
    property :image_template_id, String
    property :image_id, String
    property :location_country, String
    property :location_geo_type, String
    property :location_geo_level, String
    property :location_geo_lat, String
    property :location_geo_lng, String
    property :location_town, String
    property :sector, String
    property :created_at, DateTime
    property :updated_at, DateTime
    
    
    # {"journal_entries"=>[{"body"=>"Thank you for your loan.  It has been disbursed to Arcenia Esperanza by Prisma Microfinance in Honduras.  We are excited to watch this business grow.  Over the next 5 - 9 months, Prisma Microfinance will be collecting repayments from this entrepreneur and posting progress updates on the Kiva website.", "date"=>"2007-02-09T14:51:57Z", "comment_count"=>0, "author"=>"Kendall Mau", "subject"=>"Loan has been disbursed", "id"=>5179, "bulk"=>true}], "paging"=>{"total"=>1, "page_size"=>20, "pages"=>1, "page"=>1}}
    # ["body", "date", "comment_count", "author", "subject", "id", "bulk"]
    
    # Associations
    belongs_to :partner, :class_name => 'Kiva::Partner'
    
  end # Journal
end # Kiva