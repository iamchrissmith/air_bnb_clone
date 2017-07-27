FactoryGirl.define do

  factory :reservation do
    start_date "2017-05-16"
    end_date "2017-05-17"
    number_of_guests 1
    property
    association :renter, factory: :user
    status 1
  end
end