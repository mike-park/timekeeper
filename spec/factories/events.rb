# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event do
    therapist
    client
    event_category
    occurred_on "2013-01-19"
  end
end
