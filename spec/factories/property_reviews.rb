FactoryGirl.define do
  factory :property_review do
    property
    user
    rating 1
    body "MyString"
    reservation
  end
end
