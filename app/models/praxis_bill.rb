class PraxisBill < ActiveRecord::Base
  belongs_to :user
  has_many :bills, dependent: :nullify
  has_many :bill_items, through: :bills
  has_many :events, through: :bill_items, include: [:client, :therapist, :event_category]

  validates_presence_of :billed_on, :number
  scope :by_most_recent, -> { order('billed_on desc') }

  def events_by_clients
    grouped = events.group_by do |event|
      event.client
    end
    grouped.keys.sort.map {|k| grouped[k] }
  end

end
