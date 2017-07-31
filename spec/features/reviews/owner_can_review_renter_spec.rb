require 'rails_helper'

RSpec.feature 'User can review a property' do
  context 'when the user has stayed at the property' do
    let(:user) { create(:user) }
    let(:owner) { create(:user) }
    let(:property) { create(:property, owner: owner) }
    let!(:reservation) { create(:reservation,
                          renter: user,
                          status: 3,
                          property: property
                        )}
    let!(:review) { create(:property_review,
                            property: reservation.property,
                            rating: 5,
                            reservation: reservation
                          )}
    context 'when the owner has not yet reviewed the renter'do
      it 'the owner is able to review the renter only once' do
        login(owner)

        visit user_property_path(property)

        within ('.tab-content #finished-requests') do
          expect(page).to have_link "Review Renter"
          click_on "Review Renter"
        end

        fill_in "Comments", with: 'Lorem Ipsum'
        choose 'user_review_rating_4'
        click_on 'Submit Review'

        expect(current_path).to eq user_property_path(property)

        expect(page).to have_css('#reviews')
        within ('.tab-content #finished-requests') do
          expect(page).not_to have_link "Review Renter"
        end
      end
    end
  end
end
