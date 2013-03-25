class Bill < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller.current_user },
          recipient: ->(controller, model) { model.therapist },
          params: {
              therapist_full_name: :therapist_full_name,
              billed_on: :billed_on,
              total: :total
          },
          except: :update

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

  def generate_number
    [therapist_abbrv, Date.current.to_s(:bill)].compact.join('-')
  end

  def total
    @total ||= bill_items.map(&:price).inject(0) {|memo, price| memo + price}
  end

  def title
    [billed_on.to_s(:de), number, therapist.full_name].reject(&:blank?).join(" / ")
  end
end
