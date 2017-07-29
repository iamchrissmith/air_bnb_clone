class Property < ApplicationRecord
  extend FairBnb::PropertyApiHelpers

  belongs_to :room_type
  belongs_to :owner, class_name: "User", foreign_key: "owner_id"

  has_many :reservations
  has_many :property_availabilities

  validates :name, :number_of_guests, :number_of_beds, :number_of_rooms,
            :description, :price_per_night, :address, :city, :state, :zip,
            :image_url, :status, presence: true

  geocoded_by :geocode_address,  :latitude  => :lat, :longitude => :long
  after_validation :geocode

  enum status: %w(pending active archived)

  def prepare_address
    [address, city, state, zip].compact.join('+')
  end

  def geocode_address
    [address, city, state, zip].compact.join(', ')
  end

  def two_digit_price
    '%.2f' % price_per_night.to_f
  end

  def get_weather
    service = WeatherService.new({city: city, state: state})
    raw_weather = service.find_by_location

    if raw_weather == nil
      "Invalid city name; no weather information available."
    else
    Weather.new(raw_weather)
    end
  end

  def format_check_in_time
    DateTime.parse(check_in_time).strftime("%l:%M%P")
  end

  def format_check_out_time
    DateTime.parse(check_out_time).strftime("%l:%M%P")
  end

  def self.search_city_dates_guests(params)
    check_in_date, check_out_date, number_of_dates = dates(params)
    prop_avails = joins(:property_availabilities).merge(PropertyAvailability.available).where("number_of_guests >= ? AND city LIKE ? AND property_availabilities.date >= ? AND property_availabilities.date <= ?", params[:guests], "%#{params[:city]}%", check_in_date, check_out_date)
    array = joins(:property_availabilities).merge(PropertyAvailability.available).where('property_availabilities.date >= ? AND property_availabilities.date <= ?', check_in_date, check_out_date).pluck(:id)
    (prop_avails.select {|pa| array.count(pa.id) == number_of_dates}).uniq
  end

  def self.search_city_guests(params)
    where('city LIKE ? AND number_of_guests >= ?', "%#{params[:city]}%", params[:guests])
  end

  def self.search_dates_guests(params)
    check_in_date, check_out_date, number_of_dates = dates(params)
    prop_avails = joins(:property_availabilities).merge(PropertyAvailability.available).where("number_of_guests >= ? AND property_availabilities.date >= ? AND property_availabilities.date <= ?", params[:guests], check_in_date, check_out_date)
    array = joins(:property_availabilities).merge(PropertyAvailability.available).where('property_availabilities.date >= ? AND property_availabilities.date <= ?', check_in_date, check_out_date).pluck(:id)
    (prop_avails.select {|pa| array.count(pa.id) == number_of_dates}).uniq
  end

  def self.search_dates_city(params)
    check_in_date, check_out_date, number_of_dates = dates(params)
    prop_avails = joins(:property_availabilities).merge(PropertyAvailability.available).where('city LIKE ? AND property_availabilities.date >= ? AND property_availabilities.date <= ?', "%#{params[:city]}%", check_in_date, check_out_date)
    array = joins(:property_availabilities).merge(PropertyAvailability.available).where('property_availabilities.date >= ? AND property_availabilities.date <= ?', check_in_date, check_out_date).pluck(:id)
    (prop_avails.select {|pa| array.count(pa.id) == number_of_dates}).uniq
  end

  def self.search_dates(params)
    check_in_date, check_out_date, number_of_dates = dates(params)
    prop_avails = joins(:property_availabilities).merge(PropertyAvailability.available).where('property_availabilities.date >= ? AND property_availabilities.date <= ?', check_in_date, check_out_date)
    array = joins(:property_availabilities).merge(PropertyAvailability.available).where('property_availabilities.date >= ? AND property_availabilities.date <= ?', check_in_date, check_out_date).pluck(:id)
    (prop_avails.select {|pa| array.count(pa.id) == number_of_dates}).uniq
  end

  def self.search_city(params)
    where('city LIKE ?', "%#{params[:place_search]}%")
  end

  def self.search_guests(params)
    where("number_of_guests >= ?", params[:guests])
  end

  def self.dates(params)
    check_in_date = params[:check_in].to_date
    check_out_date = params[:check_out].to_date
    number_of_dates = check_out_date - check_in_date + 1
    return check_in_date, check_out_date, number_of_dates
  end

end
