require 'spec_helper'

describe MissingSignatureService do

  context MissingSignatureService::Reminder do
    let(:limit) { MissingSignatureService::Reminder::SMS_LIMIT }
    let(:events) { double(:events) }
    let(:today) { 0 }
    let(:reminder) { MissingSignatureService::Reminder.new(events, today) }

    it "should handle a long line" do
      smses = reminder.send(:create_smses, 'header', ['a' * limit])
      expect(smses.length).to eq(1)
      expect(smses.first.length).to be < limit
    end

    context "two events" do
      let(:events) { [
          double(client_full_name: 'mike', occurred_on: Date.current),
          double(client_full_name: 'mike', occurred_on: Date.current - 7.days),
          double(client_full_name: 'bob', occurred_on: Date.yesterday)
      ] }

      context "today" do
        let(:today) { Date.current.wday }
        it "should message only mike" do
          smses = reminder.smses
          expect(smses.length).to eq(1)
          expect(smses.first).to match(/mike/)
          expect(smses.first).to match(/\d\d\.\d\d, \d\d\.\d\d/)
        end
      end

      context "yesterday" do
        let(:today) { Date.yesterday.wday }
        it "should message only bob" do
          smses = reminder.smses
          expect(smses.length).to eq(1)
          expect(smses.first).to match(/bob/)
        end
      end

      context "tomorrow" do
        let(:today) { Date.tomorrow.wday }
        it "should not send a message" do
          smses = reminder.smses
          expect(smses.length).to eq(0)
        end
      end
    end
  end
end