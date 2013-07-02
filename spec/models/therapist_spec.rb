require 'spec_helper'

describe Therapist do
  it "should have compound names" do
    therapist = FactoryGirl.create(:therapist, first_name: 'first', last_name: 'last')
    expect(therapist.full_name).to eq('first last')
    expect(therapist.title).to eq('first last')
    expect(therapist.name).to eq('first last')
  end
end
