require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    context "user is valid with all attributes" do
      # it { should validate_presence_of(:first_name) }
      # it { should validate_presence_of(:last_name) }
      it { should validate_presence_of(:email) }
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

    context "invalid" do
      it "is invalid without email" do
        user = build(:user, email: nil)

        expect(user).to_not be_valid
      end
    end

    context "invalid with non-unique email" do
      it "is invalid without email" do
        user1 = create(:user)
        redundant_email = user1.email
        user2 = build(:user, email: redundant_email)

        expect(user2).to_not be_valid
      end
    end

    describe "relationships" do
      context "has many reservations and properties" do
        it { should have_many :reservations }
        it { should have_many :properties }
      end
    end

    describe "attributes" do
      it { should respond_to :image_url }
      it { should respond_to :phone_number }
      it { should respond_to :description }
      it { should respond_to :hometown }
      it { should respond_to :role }
      it { should respond_to :active? }
    end
  end
end
