class BillSerializer < ActiveModel::Serializer
  attributes :id, :billed_on, :number
  has_one :therapist
  has_many :bill_items
  has_many :clients, serializer: ClientIndexSerializer
  has_many :event_categories

  def event_categories
    EventCategory.all
  end

  def clients
    Client.all
  end

  def bill_items
    (object.bill_items + object.therapist.unbilled_items).sort
  end
end
