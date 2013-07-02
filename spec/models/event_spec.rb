require 'spec_helper'

describe Event do
  context "activity" do
    it "should log creation" do
      expect {FactoryGirl.create(:event)}.to change(PublicActivity::Activity, :count).by(1)
      #ap PublicActivity::Activity.last
    end
  end
end
