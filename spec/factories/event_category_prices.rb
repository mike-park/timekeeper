# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event_category_price do
    title 'As of now'
    price 9.99
    event_category
    therapist_list ['sw']
  end
end
