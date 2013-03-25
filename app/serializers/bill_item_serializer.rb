class BillItemSerializer < ActiveModel::Serializer
  attributes :id, :price
  has_one :bill
  has_one :client
  has_one :event
end
