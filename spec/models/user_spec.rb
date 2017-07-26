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

  context "relationships" do
      it { should have_many :reservations }
      it { should have_many :properties }
      it { should have_many :messages }
  end

  context "full_name" do
    it "can put together full name" do
      user = create(:user)

      expect(user.full_name).to eq("#{user.first_name} #{user.last_name}")
    end
  end

  context "from_google_omniauth" do
    it "can create user from google" do
      user = User.from_google_omniauth(stub_google)

      expect(user).to be_a(User)
      expect(user.google_uid).to eq("108878560139118396968")
      expect(user.email).to eq("bethknight1234@gmail.com")
      expect(user.first_name).to eq("Beth")
      expect(user.last_name).to eq("K")
    end
  end

  context "from_fb_omniauth" do
    it "can create user from facebook" do
      user = User.from_fb_omniauth(stub_facebook)

      expect(user).to be_a(User)
      expect(user.facebook_uid).to eq("12345")
      expect(user.email).to eq("ward.colleen.a@gmail.com")
      expect(user.first_name).to eq("Colleen")
      expect(user.last_name).to eq("Ward")
    end
  end

end