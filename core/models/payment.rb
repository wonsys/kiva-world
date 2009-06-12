module Kiva
  class Payment < Kiva::Resource
    include DataMapper::Resource
    
    # Properties
    property :id,               Serial
    property :local_amount,     Integer
    property :amount,           Integer
    property :comment,          String
    property :processed_date,   DateTime
    property :due_date,         DateTime
    property :settlement_date,  DateTime
    property :created_at,       DateTime
    property :updated_at,       DateTime
    
    # Associations
    belongs_to :loan, :class_name => 'Kiva::Loan'
  end # Payment
end # Kiva