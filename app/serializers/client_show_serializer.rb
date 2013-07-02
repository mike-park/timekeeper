class ClientShowSerializer < ActiveModel::Serializer
  attributes :id, :full_name, :active, :dob, :url
  has_many :notifications, serializer: NotificationSerializer

  def url
    client_path(object)
  end

  def notifications
    PublicActivity::Activity.where(recipient_type: object.class, recipient_id: object.id).order('created_at desc')
  end
end
