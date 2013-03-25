# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event do
    therapist nil
    event_category nil
    user nil
    occurred_on "2013-01-19"
    client nil
  end
end
