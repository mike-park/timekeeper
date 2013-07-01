# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event_category do
    title "Einzel-therapie"
    abbrv "ET"
    sort_order 0
    color '#099'
    active true
    after(:create) do |ec, evaluator|
      FactoryGirl.create(:event_category_price, event_category: ec)
    end
  end
end
