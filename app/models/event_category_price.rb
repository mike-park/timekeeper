class EventCategoryPrice < ActiveRecord::Base
  belongs_to :event_category

  acts_as_taggable_on :therapists

  validates_presence_of :title, :event_category_id

  scope :by_most_recent, -> { order('updated_at desc') }
  scope :for_therapist, ->(abbrv) { tagged_with(abbrv).by_most_recent }

end
