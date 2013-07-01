# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :bill do
    billed_on "2013-01-23"
    therapist
    number "MyString"
  end
end
