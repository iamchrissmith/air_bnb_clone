require 'rails_helper'

RSpec.describe Property, type: :model do
  context "property is valid with all attributes" do
    before do
      @room_type = create(:room_type)
      @owner = create(:user)
    end
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:number_of_guests) }
    it { should validate_presence_of(:number_of_beds) }
    it { should validate_presence_of(:number_of_rooms) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:price_per_night) }
    it { should validate_presence_of(:address) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:state) }
    it { should validate_presence_of(:zip) }
    it { should validate_presence_of(:image_url) }
    it { should validate_presence_of(:status) }
    it { should belong_to :owner }
    it { should belong_to :room_type }
  end

    it "is invalid without name" do
      property = build(:property, name: nil, owner: @owner, room_type: @room_type)
      expect(property).to_not be_valid
    end

    it "is invalid without number_of_guests" do
      property = build(:property, number_of_guests: nil, owner: @owner, room_type: @room_type)
      expect(property).to_not be_valid
    end

    it "is invalid without number_of_beds" do
      property = build(:property, number_of_beds: nil, owner: @owner, room_type: @room_type)
      expect(property).to_not be_valid
    end

    it "is invalid without number_of_rooms" do
      property = build(:property, number_of_beds: nil, owner: @owner, room_type: @room_type)
      expect(property).to_not be_valid
    end

    it "is invalid without description" do
      property = build(:property, description: nil, owner: @owner, room_type: @room_type)
      expect(property).to_not be_valid
    end

    it "is invalid without price_per_night" do
      property = build(:property, price_per_night: nil, owner: @owner, room_type: @room_type)
      expect(property).to_not be_valid
    end

    it "is invalid without address" do
      property = build(:property, address: nil, owner: @owner, room_type: @room_type)
      expect(property).to_not be_valid
    end

    it "is invalid without city" do
      property = build(:property, city: nil, owner: @owner, room_type: @room_type)
      expect(property).to_not be_valid
    end

    it "is invalid without state" do
      property = build(:property, state: nil, owner: @owner, room_type: @room_type)
      expect(property).to_not be_valid
    end

    it "is invalid without zip" do
      property = build(:property, zip: nil, owner: @owner, room_type: @room_type)
      expect(property).to_not be_valid
    end

    it "is invalid without image_url" do
      property = build(:property, image_url: nil, owner: @owner, room_type: @room_type)
      expect(property).to_not be_valid
    end

    it "is invalid without status" do
      property = build(:property, status: nil, owner: @owner, room_type: @room_type)
      expect(property).to_not be_valid
    end

    it "is invalid without owner" do
      property = build(:property, owner: nil, room_type: @room_type)
      expect(property).to_not be_valid
    end

    it "is invalid without room_type" do
      property = build(:property, room_type: nil, owner: @owner)
      expect(property).to_not be_valid
    end
end
