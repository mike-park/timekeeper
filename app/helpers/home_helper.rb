module HomeHelper
  def signature_week_reminders(therapist)
    return [] unless therapist

    (0..6).inject([]) do |memo, i|
      date = Date.current + i
      reminders = MissingSignatureService.new(therapist, date.wday).reminders
      memo += [[date, reminders]] if reminders.any?
      memo
    end
  end
end
