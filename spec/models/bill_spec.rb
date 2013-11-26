require 'spec_helper'

describe Bill do
  context "unique numbers" do
    it "should not reuse numbers" do
      bill = FactoryGirl.create(:bill)
      bill.number = bill.generate_number
      bill.save!
      bill = bill.dup
      expect(bill).to_not be_valid
      bill.number = bill.generate_number
      expect(bill).to be_valid
    end
  end
end
