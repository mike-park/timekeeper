class MissingSignatureService
  attr_reader :therapist, :wday

  def initialize(therapist, wday = Date.current.wday)
    @therapist = therapist
    @wday = wday
  end

  def events
    Event.includes(:client).
        unbilled(before_date).
        of_therapist(therapist).
        order('clients.fingerprint asc, events.occurred_on')
  end

  def send_smses
    return unless sms_reminders?
    smses.each do |sms|
      Sms.new(therapist.phone, sms).send
    end
  end

  def reminders
    @reminders ||= Reminder.new(events, wday).reminders
  end

  private

  def smses
    @smses ||= FormatReminder::SmsFormatter.new(reminders).to_smses
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
    attr_reader :events, :wday

    def initialize(events, wday = Date.current.wday)
      @events = events
      @wday = wday
    end

    def valid?
      reminders.any?
    end

    def reminders
      clients_seen_today.inject({}) do |memo, client|
        memo[client] = missing_dates_for(client)
        memo
      end
    end

    private

    def missing_dates_for(client_full_name)
      events.map do |event|
        event.occurred_on if event.client_full_name == client_full_name
      end.compact.sort
    end

    def clients_seen_today
      events.map do |event|
        event.client_full_name if event.occurred_on.wday == wday
      end.compact.uniq.sort
    end
  end

  module FormatReminder
    class SmsFormatter
      SMS_LIMIT = 160
      HEADER = "Signatures:"

      attr_reader :reminders

      def initialize(reminders)
        @reminders = reminders
      end

      def to_smses
        lines = reminders_to_lines
        lines_to_smses(HEADER, lines)
      end

      private

      def lines_to_smses(header, lines)
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

      def reminders_to_lines
        reminders.inject([]) do |memo, (client, dates)|
          formatted_dates = format_dates(dates)
          memo << "#{client}: #{formatted_dates}"
          memo
        end
      end

      def format_dates(dates)
        dates.sort.map do |date|
          date.strftime("%d.%m")
        end.join(", ")
      end

    end
  end
end
