require 'spec_helper'

describe MissingSignatureService do

  context MissingSignatureService::Reminder do
    let(:reminder) { MissingSignatureService::Reminder.new(events, wday) }
    let(:reminders) { reminder.reminders }

    context "two events" do
      let(:events) { [
          double(client_full_name: 'mike', occurred_on: Date.current),
          double(client_full_name: 'mike', occurred_on: Date.current - 7.days),
          double(client_full_name: 'bob', occurred_on: Date.yesterday)
      ] }

      context "today" do
        let(:wday) { Date.current.wday }
        it "should have a reminder for mike" do
          expect(reminders.keys.length).to eq(1)
          expect(reminders.keys.first).to eq('mike')
          expect(reminders.values.first).to eq([Date.current - 7.days, Date.current])
        end
      end

      context "yesterday" do
        let(:wday) { Date.yesterday.wday }
        it "should have a reminder for bob" do
          expect(reminders.keys.length).to eq(1)
          expect(reminders.keys.first).to eq('bob')
          expect(reminders.values.first).to eq([Date.yesterday])
        end
      end

      context "tomorrow" do
        let(:wday) { Date.tomorrow.wday }
        it "should have no reminder" do
          expect(reminders.keys.length).to eq(0)
        end
      end
    end
  end

  context MissingSignatureService::FormatReminder::SmsFormatter do
    let(:sms_formatter) { MissingSignatureService::FormatReminder::SmsFormatter.new(reminders) }
    let(:smses) { sms_formatter.to_smses }

    context "SMS_LIMIT" do
      let(:limit) { MissingSignatureService::FormatReminder::SmsFormatter::SMS_LIMIT }
      let(:reminders) { {'a' * limit => [Date.current]} }

      it "should truncate long client name" do
        expect(smses.length).to eq(1)
        expect(smses.first.length).to be < limit
      end
    end

    context "two dates" do
      let(:reminders) { {'mike' => [Date.current, Date.current - 7.days]} }

      it "should have 1 sms" do
        expect(smses.length).to eq(1)
      end

      it "should match format" do
        expect(smses.first).to match(/mike: \d\d\.\d\d, \d\d\.\d\d/)
      end
    end

    context "no dates" do
      let(:reminders) { {} }

      it "should have no smses" do
        expect(smses.length).to eq(0)
      end
    end
  end
end
