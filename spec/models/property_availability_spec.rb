require 'rails_helper'

RSpec.describe PropertyAvailability, type: :model do

  describe "validations" do

    it {should validate_presence_of(:date)}
    it {should belong_to :property}

    it "is invalid without date" do
      property_availability = build(:property_availability, date: nil, property: @property)
      expect(property_availability).to_not be_valid
    end
  end

  describe 'sql queries' do

    it "can scope to all property availabilities that are not reserved" do
      pa = create(:property_availability, reserved?: false)
      pa2 = create(:property_availability)
      pa3 = create(:property_availability, reserved?: false)

      pas = PropertyAvailability.available

      expect(pas.count).to eq(2)
      expect(pas.first.id).to eq(pa.id)
    end
  end

  describe 'helper methods' do

    it "can set available dates" do
      property = create(:property)
      avail_dates = property.property_availabilities.set_availability(Date.today, (Date.today + 5))

      expect(avail_dates.count).to eq(6)
      expect(PropertyAvailability.count).to eq(6)
      expect(avail_dates.first).to be_a(PropertyAvailability)
    end
  end
end