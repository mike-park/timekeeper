# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name 'Mike Park'
    sequence(:email) { |n| "example#{n}@example.com" }
    password 'pleaseplease'
    password_confirmation 'pleaseplease'
    # required if the Devise Confirmable module is used
    # confirmed_at Time.now
    factory :user_with_therapist do
      therapist
    end
  end
end