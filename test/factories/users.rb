# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:username) { |i| "Username#{i}" }
    sequence(:email) { |i| "user#{i}@example.com" }
    first_name "Bob"
    last_name "Thomas"
    password "aB1!cD2@"
    password_confirmation "aB1!cD2@"
    
    ignore do
      certificates_count 5
    end

    after(:create) do |user, evaluator|
      FactoryGirl.create_list(:certificate, evaluator.certificates_count, user: user)
    end
  end
end
