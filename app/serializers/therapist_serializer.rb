class TherapistSerializer < ActiveModel::Serializer
  attributes :id, :text

  def text
    object.full_name
  end
end
