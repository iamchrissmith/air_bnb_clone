FactoryGirl.define do
  factory :user do
    first_name 'User'
    last_name 'Mc Userface'
    image_url 'http://www.picture.com'
    sequence(:email) { |n| "user#{n}@gmail.com" }
    phone_number '123-456-7890'
    description 'Im a user with a Murry face'
    hometown 'Knoxville'
    role 0
    active? false
    password "password"
    facebook_token ENV['FACEBOOK_USER_TOKEN']
  end
end