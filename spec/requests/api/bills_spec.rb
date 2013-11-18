require 'spec_helper'

describe "Bills API" do
  before do
    sign_in_as_therapist
  end

  it "retrieves the initial bill" do
    FactoryGirl.create(:event, therapist: @user.therapist)
    get new_api_bill_path
    expect(response).to be_success
    expect(json['bill']['billed_on']).to eq(Date.current.strftime('%Y-%m-%d'))
    expect(json['bill']['number']).to be
    expect(json['bill']['bill_items'].count).to eq(1)
    expect(json['bill']['clients'].count).to eq(1)
    expect(json['bill']['event_categories'].count).to eq(1)
  end
end
