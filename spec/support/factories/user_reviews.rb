FactoryGirl.define do
  factory :user_review do
    user nil
    rating 1
    body "MyString"
    reservation nil
  end
end
