require 'rails_helper'

RSpec.describe PropertyReview, type: :model do
  context "Relationships" do
    it { should belong_to :user }
    it { should belong_to :property }
    it { should belong_to :reservation }
  end
end
