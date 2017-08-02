require 'rails_helper'

RSpec.describe Conversation, type: :model do
  describe 'relationships' do
    it { should belong_to(:author) }
    it { should belong_to(:receiver) }
  end
end
