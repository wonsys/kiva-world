module Kiva
  class Loan < Kiva::Resource
    include DataMapper::Resource
    
    STATUS = {1 => :fundraising,
              2 => :funded,
              3 => :in_repayment,
              4 => :paid,
              5 => :defaulted,
              6 => :refunded}
    
    # Properties
    property :id,                     String, :key => true
    property :borrower_count,         Integer
    property :status,                 Enum[*STATUS.values]
    property :name,                   String, :length => 255
    property :activity,               String, :length => 255
    property :partner_id,             Integer
    property :use,                    Text, :lazy => false
    property :loan_amount,            Integer
    property :funded_amount,          Integer
    property :paid_amount,            Integer
    property :image_template_id,      String
    property :image_id,               String
    property :video_youtube_id,       String
    property :video_id,               Integer
    property :location_country,       String
    property :location_geo_type,      String
    property :location_geo_level,     String
    property :location_geo_lat,       String
    property :location_geo_lng,       String
    property :location_town,          String
    property :journal_totals_bulk_entries, Integer
    property :journal_totals_entries, Integer
    property :terms_loan_amount,      Integer
    property :terms_disbursal_currency, String
    property :terms_disbursal_date,   DateTime
    property :sector,                 String, :length => 255
    property :posted_date,            DateTime
    property :paid_date,              DateTime
    property :funded_date,            DateTime
    property :created_at,             DateTime
    property :updated_at,             DateTime
    
    # {"status"=>"defaulted", "name"=>"Veronica Njeri Mwangi", "journal_totals"=>{"bulk_entries"=>1, "entries"=>1}, "defaulted_date"=>"2008-06-06T03:05:07Z", "payments"=>[{"local_amount"=>30, "amount"=>30, "comment"=>"scheduled payment", "processed_date"=>"2007-02-01T08:30:38Z"}, {"local_amount"=>30, "amount"=>30, "comment"=>"scheduled payment", "processed_date"=>"2007-03-02T02:03:11Z"}, {"local_amount"=>60, "amount"=>60, "comment"=>"scheduled repayment", "processed_date"=>"2007-05-01T09:25:09Z"}, {"local_amount"=>30, "amount"=>30, "comment"=>"scheduled_repayment", "processed_date"=>"2007-06-01T09:15:13Z"}, {"local_amount"=>30, "amount"=>30, "comment"=>"scheduled_repayment", "processed_date"=>"2007-07-01T09:15:19Z"}, {"local_amount"=>30, "amount"=>30, "comment"=>"scheduled_repayment", "processed_date"=>"2007-08-01T09:15:19Z"}, {"local_amount"=>30, "amount"=>30, "comment"=>"scheduled_repayment", "processed_date"=>"2007-09-01T09:15:27Z"}], "posted_date"=>"2006-11-01T01:31:34Z", "activity"=>"Dairy", "id"=>1111, "borrowers"=>[{"gender"=>"F", "pictured"=>true, "first_name"=>"Veronica", "last_name"=>"Njeri Mwangi"}], "description"=>{"texts"=>{"en"=>" Veronica is married with 5 children. All of her children are not at school and two are married. She has been securing loans from her lending group and she has proven to be very capable when it comes to repayment. She will spend the loan on buying animal feed which made a dramatic change. Her dairy animals responded positively to the feed and she was able to get higher income due to their good performance. Before introducing new feeds they increased the milk production. Water to feed the animals is not much available at her place so she is forced to employ somebody to deliver the water with wheelbarrow and also to get the feeds from the shop. She wants most of all to purchase a donkey and a cart to be carrying water and feeds and she will be able to reduce the operating costs leading to higher income. She is willing to repay the loan in installments and believes she will be able to repay all of it.\r\n\r\n\r\n \r\n\r\n"}, "languages"=>["en"]}, "terms"=>{"disbursal_date"=>"2006-11-15T08:18:25Z", "scheduled_payments"=>[{"amount"=>30, "due_date"=>"2007-02-15T08:00:00Z"}, {"amount"=>30, "due_date"=>"2007-03-15T07:00:00Z"}, {"amount"=>30, "due_date"=>"2007-04-15T07:00:00Z"}, {"amount"=>30, "due_date"=>"2007-05-15T07:00:00Z"}, {"amount"=>30, "due_date"=>"2007-06-15T07:00:00Z"}, {"amount"=>30, "due_date"=>"2007-07-15T07:00:00Z"}, {"amount"=>30, "due_date"=>"2007-08-15T07:00:00Z"}, {"amount"=>30, "due_date"=>"2007-09-15T07:00:00Z"}, {"amount"=>30, "due_date"=>"2007-10-15T07:00:00Z"}, {"amount"=>30, "due_date"=>"2007-11-15T08:00:00Z"}], "disbursal_amount"=>300, "local_payments"=>[{"amount"=>30, "due_date"=>"2006-12-15T08:00:00Z"}, {"amount"=>30, "due_date"=>"2007-01-15T08:00:00Z"}, {"amount"=>30, "due_date"=>"2007-02-15T08:00:00Z"}, {"amount"=>30, "due_date"=>"2007-03-15T07:00:00Z"}, {"amount"=>30, "due_date"=>"2007-04-15T07:00:00Z"}, {"amount"=>30, "due_date"=>"2007-05-15T07:00:00Z"}, {"amount"=>30, "due_date"=>"2007-06-15T07:00:00Z"}, {"amount"=>30, "due_date"=>"2007-07-15T07:00:00Z"}, {"amount"=>30, "due_date"=>"2007-08-15T07:00:00Z"}, {"amount"=>30, "due_date"=>"2007-09-15T07:00:00Z"}], "loan_amount"=>300, "disbursal_currency"=>"USD"}, "partner_id"=>6, "use"=>"Veronica wants to buy a donkey and a cart\r\n", "funded_amount"=>300, "funded_date"=>"2006-11-01T08:18:25Z", "image"=>{"template_id"=>1, "id"=>1401}, "location"=>{"country"=>"Kenya", "geo"=>{"type"=>"point", "level"=>"town", "pairs"=>"-1.166667 36.833333"}, "town"=>"Kiambu"}, "sector"=>"Agriculture"}
    #     >> a['loans'].first.keys
    #     => ["status", "name", "journal_totals", "defaulted_date", "payments", "posted_date", "activity", "id", "borrowers", "description", "terms", "partner_id", "use", "funded_amount", "funded_date", "image", "location", "sector"]
    
    # {"status"=>"paid", "name"=>"Arcenia Esperanza", "journal_totals"=>{"bulk_entries"=>1, "entries"=>1}, "paid_date"=>"2007-07-09T09:15:03Z", "payments"=>[{"local_amount"=>50, "amount"=>50, "processed_date"=>"2007-03-09T19:51:19Z"}, {"local_amount"=>50, "amount"=>50, "processed_date"=>"2007-04-09T15:49:50Z"}, {"local_amount"=>50, "amount"=>50, "processed_date"=>"2007-05-09T18:12:07Z"}, {"local_amount"=>50, "amount"=>50, "comment"=>"scheduled_repayment", "processed_date"=>"2007-06-09T09:15:02Z"}, {"local_amount"=>50, "amount"=>50, "comment"=>"scheduled_repayment", "processed_date"=>"2007-07-09T09:15:03Z"}], "posted_date"=>"2007-02-08T19:42:48Z", "activity"=>"Clothing Sales", "id"=>4321, "borrowers"=>[{"gender"=>"F", "pictured"=>true, "first_name"=>"Arcenia", "last_name"=>"Esperanza"}], "description"=>{"texts"=>{"es"=>"Hola mi nombre es Arcenia, soy comerciante, cuento con un negocio en mi casa de habitaci\303\263n de venta de ropa y calzado, tengo varios a\303\261os de dedicarme a este tipo de actividad la que realizo de manera ambulante y me genera ingresos para cumplir mis compromisos y cubrir mis gastos familiares, tomando en cuenta que soy madre soltera y tengo un hijo.", "en"=>"Hello. My name is Arcenia, and I am a storekeeper. I do business from home selling clothes and shoes. I have been doing this for many years. My work as a traveling salesperson helps me earn money in order to fulfill my obligations and cover household expenses, considering I am a single mother with one son.\r\n\r\n<p><b>Translated from Spanish by Alison Rives, Kiva Volunteer.</b><p>\r\n"}, "languages"=>["es", "en"]}, "terms"=>{"disbursal_date"=>"2007-02-22T23:22:40Z", "scheduled_payments"=>[{"amount"=>50, "due_date"=>"2007-05-15T07:00:00Z"}, {"amount"=>50, "due_date"=>"2007-06-15T07:00:00Z"}, {"amount"=>50, "due_date"=>"2007-07-15T07:00:00Z"}, {"amount"=>50, "due_date"=>"2007-08-15T07:00:00Z"}, {"amount"=>50, "due_date"=>"2007-09-15T07:00:00Z"}], "disbursal_amount"=>250, "local_payments"=>[{"amount"=>50, "due_date"=>"2007-03-22T07:00:00Z"}, {"amount"=>50, "due_date"=>"2007-04-22T07:00:00Z"}, {"amount"=>50, "due_date"=>"2007-05-22T07:00:00Z"}, {"amount"=>50, "due_date"=>"2007-06-22T07:00:00Z"}, {"amount"=>50, "due_date"=>"2007-07-22T07:00:00Z"}], "loan_amount"=>250, "disbursal_currency"=>"USD"}, "partner_id"=>5, "use"=>"to buy shoes, pants, socks, shirts, and other items", "funded_amount"=>250, "funded_date"=>"2007-02-08T23:22:40Z", "image"=>{"template_id"=>1, "id"=>14111}, "location"=>{"country"=>"Honduras", "geo"=>{"type"=>"point", "level"=>"town", "pairs"=>"14.033333 -86.583333"}, "town"=>"Danli"}, "sector"=>"Clothing"}
    # ["status", "name", "journal_totals", "paid_date", "payments", "posted_date", "activity", "id", "borrowers", "description", "terms", "partner_id", "use", "funded_amount", "funded_date", "image", "location", "sector"]
    
    # Associations
    belongs_to  :partner,             :class_name => 'Kiva::Partner'
    has n,      :payments,            :class_name => 'Kiva::Payment'
    has n,      :borrowers,           :class_name => 'Kiva::Borrower'
    has n,      :descriptions,        :class_name => 'Kiva::Description'
    
    class << self
      public # PUBLIC class methods
      
      # If force is true forces fetching of all objects (creates the new ones and tries to updates the old ones)
      def update_all!(force=false, deep=false)
        # update_resources(:loans, :all_loans, 'id', force)
        if deep
          Kiva::Loan.all.each {|loan| update_resources(:loans, :loan, 'id', true, ['payments', 'borrowers'], loan.id)}
        else
          update_resources(:loans, :all_loans, 'id', force, ['payments', 'borrowers'])
        end
        
        # update_resources(:loans, :all_loans, 'id', force, ['payments', 'borrowers']) do |loan, excepted_fields|
        #   payments, borrowers = excepted_fields['payments'], excepted_fields['borrowers']
        #   if payments.any?
        #     loan_payments = loan.payments
        #     loan_payments.destroy! if loan_payments.any?
        #     payments.each { |payment| loan.payments << loan.payments.build(payment)}
        #   end
        #   if borrowers.any?
        #     loan_borrowers = loan.borrowers
        #     loan_borrowers.destroy! if loan_borrowers.any?
        #     borrowers.each { |borrower| loan.borrowers << loan.borrowers.build(borrower)}
        #   end
        # end
      end
      
      def find_countries
        countries = []
        values    = []
        repository(:default).adapter.query("SELECT kiva_loans.location_country AS country, COUNT(*) AS value FROM kiva_loans
                                            WHERE kiva_loans.location_country IS NOT NULL AND kiva_loans.location_country <> ''
                                            GROUP BY kiva_loans.location_country
                                            ORDER BY value DESC").each do |loan|
          countries << loan.country.to_iso_3166
          values    << loan.value
        end
        return countries, values
      end
      
      def find_status
        status = []
        values = []
        repository(:default).adapter.query("SELECT kiva_loans.status AS status, COUNT(*) AS value FROM kiva_loans
                                            WHERE kiva_loans.status IS NOT NULL
                                            GROUP BY kiva_loans.status
                                            ORDER BY value DESC").each do |loan|
          status << "#{Kiva::Loan::STATUS[loan.status]}".capitalize.gsub('_', ' ')
          values << loan.value
        end
        return status, values
      end
    end # Loan (self)
    
    public # PUBLIC instance methods
    
    def image=(info)
      self.image_template_id = info['template_id']
      self.image_id = info['id']
    end
    
    def description=(info)
      info['text'].each do |language, text|
        self.descriptions << self.descriptions.build(:language => language, :text => text)
      end if info['text']
    end
    
    def location=(info)
      self.location_country = info['country']
      self.location_geo_type = info['geo']['type']
      self.location_geo_level = info['geo']['level']
      self.location_geo_lat, self.location_geo_lng = get_lat_lng(info['geo']['pairs'])
      self.location_town = info['town']
    end
    
    def video=(info)
      self.video_youtube_id = info['youtube_id']
      self.video_id = info['id']
    end
    
    def journal_totals=(info)
      self.journal_totals_bulk_entries = info['bulk_entries']
      self.journal_totals_entries = info['entries']
    end
    
    def terms=(info)
      self.terms_loan_amount        = info['loan_amount']
      self.terms_disbursal_currency = info['disbursal_currency']
      self.terms_disbursal_date     = info['disbursal_date']
      info['scheduled_payments'].each do |payment|
        self.payments << self.payments.build(payment)
      end
    end
    
    private # PRIVATE instance methods
    
    def get_lat_lng(geo)
      return *geo.deserialize(' ')
    end

  end # Loan
end # Kiva