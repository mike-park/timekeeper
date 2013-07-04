class Bill < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller.try(:current_user) },
          recipient: ->(controller, model) { model.therapist },
          params: {
              note: :title,
              who: :therapist_abbrv
          }

  belongs_to :praxis_bill
  belongs_to :therapist
  has_many :bill_items, dependent: :destroy, include: [:event, :client]

  accepts_nested_attributes_for :bill_items, allow_destroy: true

  validates_presence_of :billed_on, :number
  validates_uniqueness_of :number, scope: :therapist_id

  scope :by_most_recent, -> { order('billed_on desc') }
  scope :unbilled, -> { where(praxis_bill_id: nil) }

  delegate :full_name, to: :therapist, prefix: true
  delegate :abbrv, to: :therapist, prefix: true, allow_nil: true

  def self.last_bill_by(therapist)
    where(therapist_id: therapist).order('billed_on desc').first
  end

  def generate_number
    [therapist_abbrv, Date.current.to_s(:bill)].compact.join('-')
  end

  def total
    @total ||= bill_items.map(&:price).inject(0) {|memo, price| memo + price}
  end

  def title
    "Bill #{number}"
  end
end
