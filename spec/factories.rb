FactoryGirl.define do
  factory :user do
    first_name            Faker::Name.first_name
    last_name             Faker::Name.last_name
    sequence(:email)      { |n| "person_#{n}@test.com" }
    password              "foobar81"
    password_confirmation "foobar81"
  end

  factory :twitter_account do
    sequence(:handle)     { |n| "test_handle_#{n}" }
    sequence(:handle_id)  { |n| "test_handle_#{n}" }
  end 

  factory :drip_marketing_rule do
    delay                 1
    message               "Test message"
  end
end