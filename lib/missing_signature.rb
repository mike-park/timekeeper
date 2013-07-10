class MissingSignature

  def self.find(therapist, date)
    events = Event.includes(:client).
        unbilled(date).
        of_therapist(therapist).
        order('clients.fingerprint asc, events.occurred_on')
    events.map { |event| new(event) }
  end

  attr_reader :event
  delegate :client_full_name, :occurred_on, to: :event

  def initialize(event)
    @event = event
  end

end