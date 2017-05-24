class Property < ApplicationRecord
  paginates_per 25

  validates :name, :number_of_guests, :number_of_beds, :number_of_rooms, :description, :price_per_night, presence: true
  validates :address, :city, :state, :zip, :image_url, :status, presence: true

  belongs_to :room_type
  belongs_to :owner, class_name: "User", foreign_key: "owner_id"

  has_many :reservations
  has_many :property_availabilities

  enum status: %w(pending active archived)

  # geocoded_by :full_address,  :latitude  => :lat, :longitude => :long
  # after_validation :geocode
  def prepare_address
    [address, city, state, zip].compact.join('+')
  end

  def two_digit_price
    '%.2f' % price_per_night.to_f
  end

  def format_check_in_time
    DateTime.parse(check_in_time).strftime("%l:%M%P")
  end

  def format_check_out_time
    DateTime.parse(check_out_time).strftime("%l:%M%P")
  end

  def self.search_city_dates_guests(city, check_in_date, check_out_date, guests)
    prop_avails = joins(:property_availabilities).merge(PropertyAvailability.available).where("number_of_guests >= ? AND city LIKE ? AND property_availabilities.date >= ? AND property_availabilities.date <= ?", guests, "%#{city}%", check_in_date, check_out_date)
    array = joins(:property_availabilities).merge(PropertyAvailability.available).where('property_availabilities.date >= ? AND property_availabilities.date <= ?', check_in_date, check_out_date).pluck(:id)
    number_of_dates = check_out_date - check_in_date + 1
    (prop_avails.select {|pa| array.count(pa.id) == number_of_dates}).uniq
  end

  def self.search_city_guests(city, guests)
    where('city LIKE ? AND number_of_guests >= ?', "%#{city}%", guests)
  end

  def self.search_dates_guests(check_in_date, check_out_date, guests)
    prop_avails = joins(:property_availabilities).merge(PropertyAvailability.available).where("number_of_guests >= ? AND property_availabilities.date >= ? AND property_availabilities.date <= ?", guests, check_in_date, check_out_date)
    array = joins(:property_availabilities).merge(PropertyAvailability.available).where('property_availabilities.date >= ? AND property_availabilities.date <= ?', check_in_date, check_out_date).pluck(:id)
    number_of_dates = check_out_date - check_in_date + 1
    (prop_avails.select {|pa| array.count(pa.id) == number_of_dates}).uniq
  end

  def self.search_dates_city(check_in_date, check_out_date, city)
    prop_avails = joins(:property_availabilities).merge(PropertyAvailability.available).where('city LIKE ? AND property_availabilities.date >= ? AND property_availabilities.date <= ?', "%#{city}%", check_in_date, check_out_date)
    array = joins(:property_availabilities).merge(PropertyAvailability.available).where('property_availabilities.date >= ? AND property_availabilities.date <= ?', check_in_date, check_out_date).pluck(:id)
    number_of_dates = check_out_date - check_in_date + 1
    (prop_avails.select {|pa| array.count(pa.id) == number_of_dates}).uniq
  end
  
  def self.search_dates(check_in_date, check_out_date)
    prop_avails = joins(:property_availabilities).merge(PropertyAvailability.available).where('property_availabilities.date >= ? AND property_availabilities.date <= ?', check_in_date, check_out_date)
    array = joins(:property_availabilities).merge(PropertyAvailability.available).where('property_availabilities.date >= ? AND property_availabilities.date <= ?', check_in_date, check_out_date).pluck(:id)
    number_of_dates = check_out_date - check_in_date + 1
    (prop_avails.select {|pa| array.count(pa.id) == number_of_dates}).uniq
  end

  def self.search_city(city)
    where('city LIKE ?', "%#{city}%")
  end

  def self.search_guests(guests)
    where("number_of_guests >= ?", guests)
  end

end
