class Client < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller.try(:current_user) },
          recipient: ->(controller, model) { model },
          params: {
              note: :title,
              client_full_name: :full_name,
              who: ->(controller, mode) { controller.try(:current_user).try(:name) }
          }

  acts_as_taggable_on :therapists

  has_many :events

  scope :of_therapist, ->(therapist) { tagged_with(therapist.abbrv) }

  validates_presence_of :first_name, :last_name, :dob
  validates_uniqueness_of :fingerprint

  before_validation :update_fingerprint, :assign_full_name

  scope :active, -> { where(active: true) }
  scope :find_clients_with, lambda { |attrs| where(fingerprint: calc_fingerprint(attrs)) }
  scope :find_clients_without_dob, lambda {|attrs|
    where("LOWER(first_name)=LOWER(?) AND LOWER(last_name)=LOWER(?)", attrs[:first_name], attrs[:last_name])}
  default_scope order('last_name, first_name asc')

  def title
    "#{full_name} #{dob.to_s(:de)}"
  end

  def most_recent_event
    @most_recent ||= events.by_most_recent.first
  end

  def <=>(other)
    full_name <=> other.full_name
  end

  def events_from_bill(bill)
    events.from_bill(bill).by_oldest
  end

  private

  def assign_full_name
    self.full_name = [last_name, first_name].compact.join(", ")
  end

  def self.calc_fingerprint(attrs)
    attrs = attrs.with_indifferent_access
    [:last_name, :first_name, :dob].inject("") {|memo, n| memo << "#{attrs[n].to_s.strip}/".downcase }
  end

  def update_fingerprint
    self.fingerprint = self.class.calc_fingerprint(attributes)
  end

end
