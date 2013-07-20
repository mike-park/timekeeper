class MissingSignatureService
  attr_reader :therapist

  def initialize(therapist)
    @therapist = therapist
  end

  def events
    Event.includes(:client).
        unbilled(before_date).
        of_therapist(therapist).
        order('clients.fingerprint asc, events.occurred_on')
  end

  def sms_reminder
    return unless sms_reminders?
    reminder.smses.each do |sms|
      Sms.new(therapist.phone, sms).send
    end
  end

  private

  def reminder
    @reminder ||= Reminder.new(events)
  end

  def sms_reminders?
    therapist.send_reminders?
  end

  def before_date
    last_bill && last_bill.billed_on
  end

  def last_bill
    @last_bill ||= Bill.last_bill_by(therapist)
  end

  class Reminder
    SMS_LIMIT = 160
    HEADER = "Signatures:"

    attr_reader :events, :today
    def initialize(events, today = Date.current.wday)
      @events = events
      @today = today
    end

    def valid?
      client_messages.any?
    end

    def smses
      @smses ||= create_smses(HEADER, client_messages)
    end

    private

    def create_smses(header, lines)
      lines = lines.find_all(&:present?)
      return [] unless lines.any?

      smses = []
      sms = header
      lines.each do |line|
        if (header.length + line.length + 1) >= SMS_LIMIT
          line = line.slice(0, SMS_LIMIT - header.length - 3)
        end
        if (sms.length + line.length + 1) >= SMS_LIMIT
          smses << sms
          sms = header
        end
        sms += "\n#{line}"
      end
      smses << sms
      smses
    end

    def client_messages
      clients_seen_today.map do |client|
        dates = missing_dates_for(client)
        if dates
          formatted_dates = format_dates(dates)
          "#{client}: #{formatted_dates}"
        end
      end
    end

    def format_dates(dates)
      dates.sort.map do |date|
        date.strftime("%d.%m")
      end.join(", ")
    end

    def missing_dates_for(client_full_name)
      events.map do |event|
        event.occurred_on if event.client_full_name == client_full_name
      end.compact
    end

    def clients_seen_today
      events.map do |event|
        event.client_full_name if event.occurred_on.wday == today
      end.compact.uniq.sort
    end
  end
end
