# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :bill_item do
    bill
    client
    event
  end
end
