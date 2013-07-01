# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :client do
    first_name "Jonny"
    sequence :last_name do |n|
      "Rotton#{n}"
    end
    dob "2013-01-19"
  end
end
