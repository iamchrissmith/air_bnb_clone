require "rails_helper"

RSpec.feature "Messaging", type: :feature do
  before(:all) do
    @visitor = create(:user)
    @host = create(:user)
    @property = create(:property, owner_id: @host.id)
  end

  let(:visitor) { @visitor.reload }
  let(:host) { @host.reload }
  let(:property) { @property.reload }

  xscenario "User can start a chat with a host without a reservation", js: true do
    login(visitor)
    within '.all_homes' do
      click_on "#{property.name}"
    end

    within '.card_header' do
      click_on 'The Host'
    end

    click_on "Message #{host.first_name}"
    expect(page).to have_content("Trip to #{property.name}")
  end
end