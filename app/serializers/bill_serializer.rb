class BillSerializer < ActiveModel::Serializer
  attributes :id, :billed_on, :number
  has_one :therapist
end
