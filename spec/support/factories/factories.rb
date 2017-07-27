# FactoryGirl.define do

  # factory :room_type do
  #   name 0
  # end

  # factory :user do
  #   first_name Faker::User.name
  #   last_name Faker::Music.instrument
  #   image_url Faker::Fillmurray.image
  #   sequence(:email) { |n| Faker::Internet.email("sample#{n}") }
  #   phone_number Faker::PhoneNumber.cell_phone
  #   description Faker::RuPaul.quote
  #   hometown Faker::Address.city
  #   role 0
  #   active? false
  #   password "password"
  #   facebook_token ENV['FACEBOOK_USER_TOKEN']
  #
  # end

  # factory :property_availability do
  #   date "2017-05-16"
  #   reserved? true
  #   property
  # end

  # factory :reservation do
  #   start_date "2017-05-16"
  #   end_date "2017-05-17"
  #   number_of_guests 1
  #   property
  #   association :renter, factory: :user
  #   status 1
  # end

# property_images= [
# 'app/assets/images/beach_house.jpg',
# 'app/assets/images/cabin_in_the_woods.jpg',
# 'app/assets/images/urban_cottage.jpg'
# ]
#
# sequence :image_url, property_images.cycle do |n|
#   "#{n}"
# end

  # factory :property do
  #   name Faker::GameOfThrones.city
  #   number_of_guests 1
  #   number_of_beds 1
  #   number_of_rooms 1
  #   number_of_bathrooms 1
  #   description Faker::Hipster.paragraph
  #   price_per_night Faker::Commerce.price
  #   address Faker::Address.street_address
  #   city Faker::Address.city
  #   state Faker::Address.state_abbr
  #   zip Faker::Address.zip
  #   lat "39.7392"
  #   long "104.9903"
  #   room_type
  #   image_url {generate(:image_url)}
  #   check_in_time "14:00:00"
  #   check_out_time "11:00:00"
  #   status 1
  #   association :owner, factory: :user
  # end


# end
