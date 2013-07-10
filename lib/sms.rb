class Sms
  attr_reader :to, :message

  def initialize(to, message)
    @to = to
    @message = message
  end

  def send
    puts "SMS to #{to}: #{message}"
    client.account.sms.messages.create(from: from, to: to, body: message)
  end

  private

  def client
    @client ||= Twilio::REST::Client.new(account_sid, auth_token)
  end

  def from
    ENV['TWILIO_FROM']
  end

  def account_sid
    ENV['TWILIO_ACCOUNT_SID']
  end

  def auth_token
    ENV['TWILIO_AUTH_TOKEN']
  end
end