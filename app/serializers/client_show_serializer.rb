class ClientShowSerializer < ActiveModel::Serializer
  attributes :id, :full_name, :active, :dob, :url
  has_many :events

  def url
    client_path(object)
  end
end
