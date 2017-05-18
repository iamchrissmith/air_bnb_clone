FactoryGirl.define do
  
  factory :property_availability do
    date "2017-05-16"
    reserved? false
    property
  end
  
  factory :reservation do
    total_price "9.99"
    start_date "2017-05-16"
    end_date "2017-05-17"
    number_of_guests 1
    property
    user
    status "MyString"
  end
  
  factory :property do
    name "MyString"
    number_of_guests 1
    number_of_beds 1
    number_of_rooms 1
    description "MyText"
    price_per_night "300"
    address "MyString"
    city "MyString"
    state "MyString"
    zip "MyString"
    lat "39.7392"
    lon "104.9903"
    room_type 1
    image_url "MyString"
    check_in_time "14:00:00"
    check_out_time "11:00:00"
    active? false
    user
  end
  
  factory :room_type do
    name 0
  end
  
  factory :user do
    first_name Faker::User.name
    last_name Faker::Music.instrument
    image_url Faker::Fillmurray.image
    email Faker::Internet.email
    phone_number "MyString"
    description Faker::RuPaul.quote
    hometown "MyString"
    role 0
    active? false
  end
  
end