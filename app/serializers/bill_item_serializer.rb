class BillItemSerializer < ActiveModel::Serializer
  attributes :id, :event_id, :event_category_id, :client_id, :occurred_on

  def event_category_id
    object.event.event_category_id
  end

  def client_id
    object.event.client_id
  end

  def occurred_on
    object.event.occurred_on.to_s(:long_de)
  end
end
