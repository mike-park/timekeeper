class MissingSignatureSerializer < ActiveModel::Serializer
  attributes :client_full_name, :occurred_on

  def client_full_name
    object.client_full_name
  end

  def occurred_on
    object.occurred_on
  end
end
