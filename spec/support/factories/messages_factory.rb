FactoryGirl.define do
  factory :message do
    content "Say Hello to My Little Friend."
    conversation
    user
  end
end