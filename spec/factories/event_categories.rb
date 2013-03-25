# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event_category do
    title "MyString"
    abbrv "MyString"
    sort_order 1
  end
end
