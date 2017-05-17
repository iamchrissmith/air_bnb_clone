FactoryGirl.define do
  factory :property_availability do
    date "2017-05-16"
    reserved? false
    property nil
  end
  factory :reservation do
    total_price "9.99"
    start_date "2017-05-16 19:42:14"
    end_date "2017-05-16 19:42:14"
    number_of_guests 1
    property nil
    user nil
    status "MyString"
  end
  factory :property do
    name "MyString"
    number_of_guests 1
    number_of_beds 1
    number_of_rooms 1
    description "MyText"
    price_per_night "9.99"
    address "MyString"
    city "MyString"
    state "MyString"
    zip "MyString"
    lat "9.99"
    lon "9.99"
    room_type nil
    image_url "MyString"
    check_in_time "2017-05-16 19:22:19"
    check_out_time "2017-05-16 19:22:19"
    active? false
    user ""
  end
  factory :room_type do
    name "MyString"
  end
  factory :user do
    first_name "MyString"
    last_name "MyString"
    image_url "MyString"
    email "MyString"
    phone_number "MyString"
    description "MyText"
    hometown "MyString"
    role 1
    active? false
  end
  
end