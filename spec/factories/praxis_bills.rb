# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :praxis_bill do
    billed_on "2013-02-05"
    note "MyText"
    user nil
  end
end
