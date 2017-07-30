require 'rails_helper'

RSpec.describe Reservation, type: :model do
  context "reservation is valid with all attributes" do
    before do
      room_type = create(:room_type)
      @property = create(:property, room_type: room_type)
      @user = create(:user)
    end

    # it { should validate_presence_of(:total_price) }
    it { should validate_presence_of(:start_date) }
    it { should validate_presence_of(:end_date) }
    it { should validate_presence_of(:number_of_guests) }
    it { should validate_presence_of(:status) }
    it { should belong_to :property }
    it { should belong_to :renter }
    it { should have_one :property_review }
  end

    # it "is invalid without total_price" do
    #   reservation = build(:reservation, total_price: nil, renter: @user, property: @property)
    #   expect(reservation).to_not be_valid
    # end
    it "is invalid without start_date" do
      reservation = build(:reservation, start_date: nil, renter: @user, property: @property)
      expect(reservation).to_not be_valid
    end
    it "is invalid without end_date" do
      reservation = build(:reservation, end_date: nil, renter: @user, property: @property)
      expect(reservation).to_not be_valid
    end
    it "is invalid without number_of_guests" do
      reservation = build(:reservation, number_of_guests: nil, renter: @user, property: @property)
      expect(reservation).to_not be_valid
    end
    it "is invalid without status" do
      reservation = build(:reservation, status: nil, renter: @user, property: @property)
      expect(reservation).to_not be_valid
    end
    it "is invalid without renter" do
      reservation = build(:reservation, renter: nil, property: @property)
      expect(reservation).to_not be_valid
    end
    it "is invalid without property" do
      reservation = build(:reservation, property: nil, renter: @user)
      expect(reservation).to_not be_valid
    end

  context "#num_nights" do
    it "can calculate number of night" do
      reservation = create(:reservation, end_date: "2017-05-19")

      expect(reservation.num_nights).to eq(3)
    end
  end

end
