class EventSerializer < ActiveModel::Serializer
  attributes :id, :start, :title, :color, :editable, :therapist_name,
             :event_category_name, :billed_on, :updated_at, :therapist_abbrv,
             :bill_url

  def start
    date = object.occurred_on
    # js calendar code sorts by start datetime. we adjust h:m:s to allow alphabetical sort order
    secs = sort_order
    DateTime.new(date.year, date.month, date.day, (secs/3600 % 24), (secs/60 % 60), secs % 60)
  end

  def title
    object.client.full_name
  end

  def color
    object.event_category.color
  end

  def editable
    user_can_edit = if scope.has_role? :admin
                      true
                    elsif scope.therapist
                      scope.therapist == object.therapist
                    else
                      true
                    end
    user_can_edit && object.can_edit?
  end

  def therapist_name
    object.therapist.full_name
  end

  def therapist_abbrv
    object.therapist.abbrv
  end

  def event_category_name
    object.event_category.title
  end

  def bill_url
    bill_path(object.bill_id) if object.bill_id
  end

  def include_bill_url?
    object.bill_id
  end

  private

  def sort_order
    @sort_order ||= name_to_secs(object.client.full_name)
  end

  def name_to_secs(name)
    name = ActiveSupport::Inflector.transliterate(name).downcase
    name = name.gsub(/[^a-z]/, '')
    chars = name.split(//)[0...3]
    secs = chars.inject(0) do |memo, char|
      (memo*26) + char.ord - 'a'.ord
    end
    secs % 86400
  end
end
