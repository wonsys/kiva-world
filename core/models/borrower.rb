module Kiva
  class Borrower < Kiva::Resource
    include DataMapper::Resource
    
    # Properties
    property :id,          Serial
    property :gender,      Enum[:F, :M]
    property :pictured,    Boolean
    property :first_name,  String
    property :last_name,   String
    property :created_at,  DateTime
    property :updated_at,  DateTime
    
    # Associations
    belongs_to :loan, :class_name => 'Kiva::Loan'
  end # Borrower
end # Kiva