class BillItem < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller.try(:current_user) },
          recipient: ->(controller, model) { model.client },
          params: {
              note: :title,
              who: :therapist_abbrv,
              client_full_name: :client_full_name,
          }

  belongs_to :bill
  belongs_to :client
  belongs_to :event

  before_save :assign_client
  before_validation :assign_price
  after_save :assign_bill, on: :create
  before_destroy :unset_bill

  delegate :occurred_on, :event_category, :therapist, to: :event
  delegate :billed_on, to: :bill
  delegate :abbrv, to: :therapist, prefix: true
  delegate :full_name, to: :client, prefix: true

  validates_presence_of :event_id
  validates_numericality_of :price, greater_than: 0

  def self.from_events(events)
    events.map {|event| new(event: event, client: event.client) }
  end

  def self.by_name
    all.sort {|a, b| "#{a.full_name}#{a.occurred_on}" <=> "#{b.full_name}#{b.occurred_on}"}
  end

  def title
    "#{bill.title}: #{event.title}"
  end

  def event_category_title
    event.event_category.title
  end

  def <=>(other)
    event <=> other.event
  end

  private

  def assign_bill
    event.update_attribute(:bill_id, bill.id)
  end

  def unset_bill
    event.update_attribute(:bill_id, nil) if event
  end

  def assign_client
    self.client_id = event.client_id
  end

  def assign_price
    self.price = event.price
  end

end
