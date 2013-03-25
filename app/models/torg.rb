require 'csv'

class Torg < ActiveRecord::Base
  store :report, accessors: [:data]
  before_save :update_report

  validates_presence_of :start_date, :end_date

  scope :by_start_date, -> { order('start_date, created_at asc') }
  scope :with_dates, ->(start_date, end_date) { where(start_date: start_date, end_date: end_date) }

  attr_accessor :compare_id

  CSV_FIELDS = %w(Nachname Vorname Behandlungsdatum Therapieeinheit Therapeut)

  def events
    Event.includes(:client, :therapist, :event_category).occurred_between(start_date..end_date).order('clients.last_name, clients.first_name, events.occurred_on asc')
  end

  def to_csv
    CSV.generate(:force_quotes => true, :encoding => 'utf-8') do |csv|
      csv << CSV_FIELDS
      data.each do |row|
        csv << row
      end
      csv
    end
  end

  def title
    @title ||= "#{start_date.to_s(:de)} bis #{end_date.to_s(:de)}"
  end

  def related
    @related ||= self.class.with_dates(start_date, end_date).where('id != ?', id).by_start_date.all
  end

  private

  def update_report
    self.data = events.map do |event|
      [event.client.last_name,
       event.client.first_name,
       event.occurred_on.to_s(:de),
       event.event_category_title,
       event.therapist_full_name]
    end
  end
end
