# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :certificate do
    sequence(:contents) { |i| "ssh-rsa1 #{i} nickname" }
    sequence(:fingerprint) { |i| "Certificate Fingerprint #{i}" }
    sequence(:nickname) { |i| "Certificate Nickname #{i}" }
    user
  end
end
