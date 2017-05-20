require 'rails_helper'

RSpec.describe RoomType, type: :model do
    context "room type is valid with all attributes" do
      it { should validate_presence_of(:name) }
      it { should have_many :properties }
    end

      it "is invalid without name" do
        room_type = build(:room_type, name: nil)
        expect(room_type).to_not be_valid
      end
end
