class Reservation < ApplicationRecord
  extend FairBnb::ReservationApiHelpers

  validates :total_price, :start_date, :end_date, :number_of_guests, :status, presence: true

  belongs_to :property
  belongs_to :renter, class_name: "User", foreign_key: "renter_id"

  enum status: %w(pending confirmed in_progress finished declined)

  def num_nights
    (end_date - start_date)
  end

  def self.reservations_by_month
    self.find_by_sql("SELECT RTRIM(to_char(start_date,'Month')) AS month,  count(reservations) AS count
                      FROM reservations
                      GROUP BY to_char(start_date, 'Month')
                      ORDER BY to_char(start_date, 'Month');")
  end

  def self.reservations_by_month_city(city)
    self.find_by_sql(["SELECT RTRIM(to_char(start_date,'Month')) AS month,  count(reservations) AS count
                      FROM reservations
                      INNER JOIN properties ON reservations.property_id = properties.id
                      WHERE properties.city = ?
                      GROUP BY to_char(start_date, 'Month')
                      ORDER BY to_char(start_date, 'Month');", city])
  end
end
