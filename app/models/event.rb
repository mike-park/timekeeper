class Event < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller.try(:current_user) },
          recipient: ->(controller, model) { model.therapist },
          params: {
            therapist_full_name: :therapist_full_name,
            event_category_title: :event_category_title,
            client_full_name: :client_full_name,
            occurred_on: :occurred_on
          },
          except: :update

  belongs_to :therapist
  belongs_to :event_category
  belongs_to :user
  belongs_to :client
  belongs_to :bill

  validates_presence_of :therapist_id, :client_id, :event_category_id, :occurred_on

  scope :of_therapist, ->(therapist) { where(therapist_id: therapist.id) }
  scope :unbilled, ->(before) { where(bill_id: nil).where('occurred_on <= ?', before) }
  scope :by_most_recent, -> { order('occurred_on desc') }
  scope :by_oldest, -> { order('occurred_on asc') }
  scope :by_name, -> { includes(:client).order('clients.last_name, clients.first_name, occurred_on asc') }
  scope :from_bill, ->(bill) { where(bill_id: bill.id) }
  scope :occurred_between, ->(range) { where(occurred_on: range)}

  delegate :title, to: :event_category, prefix: true
  delegate :full_name, to: :therapist, prefix: true
  delegate :full_name, to: :client, prefix: true

  def <=>(other)
    client <=> other.client
  end

  def price
    price = event_category.event_category_prices.for_therapist(therapist.abbrv).first
    price.price if price
  end

  def billed_on
    bill.billed_on if bill
  end

  def billed?
    bill_id
  end

  def can_edit?
    not billed?
  end
end
