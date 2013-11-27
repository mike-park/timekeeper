require 'spec_helper'

describe 'Factories' do
  [:event, :client, :bill, :bill_item, :event_category, :event_category_price,
   :therapist, :user
  ].each do |name|
    it "should create #{name} from factory" do
      FactoryGirl.create(name)
    end
  end
end
