# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :therapist do
    first_name "Sabine"
    last_name "Wolff"
    abbrv "SW"
    category 'GO'
  end
end
