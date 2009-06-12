module Kiva
  class Description < Kiva::Resource
    include DataMapper::Resource
    
    # Properties
    property :id,       Serial
    property :language, String
    property :text,     Text
    property :created_at, DateTime
    property :updated_at, DateTime
    
    # Associations
    belongs_to :loan, :class_name => 'Kiva::Loan'
  end # Borrower
end # Kiva