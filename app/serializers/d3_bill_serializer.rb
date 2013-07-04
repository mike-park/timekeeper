class D3BillSerializer < ActiveModel::Serializer
  attributes :time, :count

  def time
    object.billed_on.strftime("%Q").to_i
  end

  def count
    object.total
  end
end
