class Property < ApplicationRecord
  extend FairBnb::PropertyApiHelpers

  belongs_to :room_type
  belongs_to :owner, class_name: "User", foreign_key: "owner_id"

  has_many :reservations
  has_many :property_availabilities
  has_many :property_reviews

  validates :name, :number_of_guests, :number_of_beds, :number_of_rooms,
            :description, :price_per_night, :address, :city, :state, :zip,
            :image_url, :status, presence: true

  geocoded_by :geocode_address,  :latitude  => :lat, :longitude => :long
  after_validation :geocode

  enum status: %w(pending active archived)

  scope :within_zone, -> (params) { near(location_method(params[:location]), params[:location][:radius]) }
  scope :available, -> (params) { joins(:property_availabilities)
                        .where(:property_availabilities =>
                          {:date => date_range(params)[:checkin]..date_range(params)[:checkout], reserved?: false})
                        .distinct }

  scope :with_guests, -> (params) { where("number_of_guests >= ?", params[:guests]) }

  def self.search(params)
    scopes = []
    scopes << 'with_guests' if params[:guests]
    scopes << 'available' if params[:date_range]
    scopes << 'within_zone' if params[:location]

    chain_scopes(scopes, params)
  end

  def self.chain_scopes(scopes, params)
    return nil if scopes.empty?
    scopes.inject(self) { |chain, scope| chain.send(scope, params) }
  end

  def self.location_method(params)
    if params[:lat].nil? || params[:long].nil?
      "#{params[:city]}, #{params[:state]}"
    else
      [params[:lat], params[:long]]
    end
  end

  def self.date_range(params)
    { checkin: DateTime.strptime(params[:date_range].split('-')[0].strip, '%m/%d/%Y'),
      checkout: DateTime.strptime(params[:date_range].split('-')[1].strip, '%m/%d/%Y') }
  end

  def prepare_address
    [address, city, state, zip].compact.join('+')
  end

  def geocode_address
    [address, city, state, zip].compact.join(', ')
  end

  def two_digit_price
    '%.2f' % price_per_night.to_f
  end

  def reviews
    property_reviews
  end

  def average_rating
    property_reviews.average(:rating).round(2)
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
end
