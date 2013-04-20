# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :key do
    user_id 1
    contents "MyText"
    nickname "MyString"
    fingerprint "MyString"
  end
end
