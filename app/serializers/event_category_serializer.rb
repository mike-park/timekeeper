class EventCategorySerializer < ActiveModel::Serializer
  attributes :id, :text, :color

  def text
    object.title
  end
end
