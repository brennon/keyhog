# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    username "robert"
    email "bob@example.com"
    first_name "Bob"
    last_name "Thomas"
  end
end
