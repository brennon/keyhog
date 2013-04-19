# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:username) { |i| "Username#{i}" }
    sequence(:email) { |i| "user#{i}@example.com" }
    first_name "Bob"
    last_name "Thomas"
    password "notS0simple"
    password_confirmation "notS0simple"
  end
end
