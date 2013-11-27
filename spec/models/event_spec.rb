require 'spec_helper'

describe Event do
  context "activity" do
    it "should log creation" do
      # first to create related records (ie client)
      event = FactoryGirl.create(:event)
      event = event.dup
      expect {event.save}.to change(PublicActivity::Activity, :count).by(1)
      #ap PublicActivity::Activity.last
    end
  end
end
