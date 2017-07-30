require 'rails_helper'

RSpec.feature 'User can review a property' do
  context 'when the user has stayed at the property' do
    let(:user) { create(:user) }
    let!(:reservation) { create(:reservation,
                          renter: user,
                          status: 3
                        )}
    let!(:review) { create(:property_review,
                            property: reservation.property,
                            rating: 5
                          )}
    context 'when the user has not yet reviewed the property'do
      it 'the user is able to review the property' do
        login(user)

        visit dashboard_path

        within ('.tab-content #finished') do
          expect(page).to have_link "Review Property"
          click_on "Review Property"
        end

        fill_in "Comments", with: 'Lorem Ipsum'
        choose 'property_review_rating_1'
        click_on 'Submit Review'

        expect(current_path).to eq property_path(reservation.property)

        expect(page).to have_css('#reviews')
        within('#reviews') do
          expect(page).to have_content 'Reviews (1)'
          expect(page).to have_content 'Average Rating: 4.5 of 5 stars'
          expect(page).to have_content user.full_name
          expect(page).to have_content 'Lorem Ipsum'
          expect(page).to have_content '4 of 5 stars'
        end
      end
    end

    context 'when the user has already reviewed the property' do
      it 'the user does not see the review button' do
        login(user)

        visit dashboard_path

        within ('.tab-content #confirmed') do
          expect(page).not_to have_button "Review Property"
        end
      end
    end
  end
end
