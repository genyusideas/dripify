FactoryGirl.define do
  factory :user do
    first_name            Faker::Name.first_name
    last_name             Faker::Name.last_name
    email                 Faker::Internet.email
    password              "foobar81"
    password_confirmation "foobar81"
  end
end