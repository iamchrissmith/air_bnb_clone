require 'rails_helper'

RSpec.describe User, type: :model do
  # describe "validations" do
  #   context "user is valid with all attributes" do
  #     xit { should validate_presence_of(:first_name) }
  #     xit { should validate_presence_of(:last_name) }
  #     xit { should validate_presence_of(:email) }
  #     xit { should validate_presence_of(:phone_number) }
  #     xit { should validate_presence_of(:image_url) }
  #   end
  # end

  describe "relationships" do
    context "has many reservations and properties" do
      it { should have_many :reservations }
      it { should have_many :properties }
    end
  end
end

    # context "invalid" do
    #   it "is invalid without first_name" do
    #     user = build(:user, first_name: nil)
    #
    #     expect(user).to_not be_valid
    #   end
    # end
    #
    # context "invalid" do
    #   it "is invalid without last_name" do
    #     user = build(:user, last_name: nil)
    #
    #     expect(user).to_not be_valid
    #   end
    # end
    #
    # context "invalid" do
    #   it "is invalid without email" do
    #     user = build(:user, email: nil)
    #
    #     expect(user).to_not be_valid
    #   end
    # end
    #
    # context "invalid with non-unique email" do
    #   it "is invalid without email" do
    #     user1 = create(:user)
    #     redundant_email = user1.email
    #     user2 = build(:user, email: redundant_email)
    #
    #     expect(user2).to_not be_valid
    #   end
    # end
