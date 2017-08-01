require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    context "user is valid with all attributes" do
      it { should validate_uniqueness_of(:username) }
    end
  end

  context "relationships" do
      it { should have_many :reservations }
      it { should have_many :properties }
      it { should have_many :authored_conversations }
      it { should have_many :received_conversations }
      it { should have_many :messages }
      it { should have_many :property_reviews }
  end

  context "full_name" do
    it "can put together full name" do
      user = create(:user)

      expect(user.full_name).to eq("#{user.first_name} #{user.last_name}")
    end
  end

  describe '.reviewed_property?' do
    let!(:user) { create(:user) }
    let(:reservation) { create(:reservation, renter: user) }
    context 'when there is a reservation with no review' do
      it 'returns false' do
        expect(user.reviewed_property?(reservation)).to be false
      end
    end

    context 'when there is a reservation with a review' do
      let!(:review) { create(:property_review, reservation: reservation, property: reservation.property, user: user) }
      it 'returns true' do
        expect(user.reviewed_property?(reservation)).to be true
      end
    end
  end

  describe '.reviewed_renter?' do
    let!(:user) { create(:user) }
    let!(:owner) { create(:user) }
    let!(:property) { create(:property, owner: owner) }
    let!(:reservation) { create(:reservation,
                          renter: user,
                          status: 3,
                          property: property
                        )}
    context 'when there is a reservation with no review' do
      it 'returns false' do
        expect(owner.reviewed_renter?(reservation)).to be false
      end
    end

    context 'when there is a reservation with a review' do
      let!(:review) { create(:user_review, reservation: reservation, renter: reservation.renter, user: owner) }
      it 'returns true' do
        expect(owner.reviewed_renter?(reservation)).to be true
      end
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