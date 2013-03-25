class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :therapists
  has_one :therapist
  has_many :therapists
  has_many :event_categories

  def therapists
    Therapist.all
  end

  def event_categories
    EventCategory.active
  end
end
