require 'rails_helper'

RSpec.describe RoomType, type: :model do
  describe "validations" do
    context "room type is valid with all attributes" do
      it { should validate_presence_of(:name) }
    end

    context "invalid" do
      it "is invalid without name" do
        room_type = build(:room_type, name: nil)

        expect(room_type).to_not be_valid
      end
    end

    describe "relationships" do
      context "has many properties" do
        it { should have_many :properties }
      end
    end
  end
end
