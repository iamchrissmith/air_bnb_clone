require 'rails_helper'

RSpec.describe Message, type: :model do
  describe 'valid attributes' do
    it { should validate_presence_of(:content) }
  end

  describe 'relationships' do
    it { should have_many(:users) }
    it { should have_many(:conversations) }
  end
end
