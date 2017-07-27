FactoryGirl.define do
  factory :message do
    user
    conversation
    content "Say Hello to My Little Friend."
  end
end