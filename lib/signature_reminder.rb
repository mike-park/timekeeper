class SignatureReminder
  attr_reader :therapist

  def initialize(therapist)
    @therapist = therapist
  end

  def send
    return unless therapist.phone && therapist.send_reminders
    Sms.new(therapist.phone, reminder).send if clients_seen_today.any?
  end

  def reminder
    @reminder ||= "Needed Signatures\n#{formatted_clients}"
  end

  def formatted_clients
    clients_seen_today.map do |client|
      dates = missing_dates_for(client)
      if dates
        formatted_dates = format_dates(dates)
        "#{dates.length} #{client}: #{formatted_dates}"
      end
    end.join("\n")
  end

  def format_dates(dates)
    dates.map do |date|
      date.to_s(:de)
    end.join(", ")
  end

  def missing_signatures
    @missing_signatures ||= begin
      last_bill = Bill.last_bill_by(therapist)
      MissingSignature.find(therapist, last_bill.billed_on)
    end
  end

  def missing_dates_for(client_full_name)
    missing_signatures.map do |signature|
      signature.occurred_on if signature.client_full_name == client_full_name
    end.compact
  end

  def clients_seen_today
    missing_signatures.map do |signature|
      signature.client_full_name if signature.occurred_on.wday == today
    end.compact.uniq
  end

  def today
    3 #Date.current.wday
  end
end