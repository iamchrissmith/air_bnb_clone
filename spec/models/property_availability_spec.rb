require 'rails_helper'

RSpec.describe PropertyAvailability, type: :model do
  context "property availability is valid with all attributes" do

    before do
      room_type = create(:room_type)
      owner = create(:user)
      @property = create(:property, room_type: room_type, owner: owner)
    end

    it {should validate_presence_of(:date)}
    it {should validate_presence_of(:reserved?)}
    it {should belong_to :property}
  end

  it "is invalid without date" do
    property_availability = build(:property_availability, date: nil, property: @property)
    expect(property_availability).to_not be_valid
  end

  it "is invalid without reserved status" do
    property_availability = build(:property_availability, reserved?: nil, property: @property)
    expect(property_availability).to_not be_valid
  end
end
