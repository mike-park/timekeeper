class NotificationSerializer < ActiveModel::Serializer
  attributes :occurred_on, :note, :who, :icon

  def occurred_on
    object.created_at
  end

  def note
    p = object.parameters
    msg = p[:note]
    msg ||= "#{p[:event_category_title]} #{p[:occurred_on].to_s(:de)}" if p[:occurred_on]
    msg ||= "Bill #{p[:billed_on].to_s(:de)}" if p[:billed_on]
    msg || p[:event_category_title]
  end

  def who
    object.parameters[:who] || object.parameters[:therapist_full_name]
  end

  def icon
    case object.key
      when /\.destroy/
        "icon-trash"
      when /\.create/
        "icon-plus"
      else
        "icon-edit"
    end
  end
end
