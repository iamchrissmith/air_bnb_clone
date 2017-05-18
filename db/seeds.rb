
class Seed

  def initialize
    generate_users
    generate_properties
  end

  def generate_users
    1000.times do |i|
      user = User.create!(email: Faker::Internet.email,
                          first_name: ,
                          last_name: ,
                          image_url: ,
                          phone_number:
                          description: ,
                          hometown: ,
                          role: ,
                          active?:

      )
  end


  def generate_properties
    500.times do |i|
      property = Property.create!(name: ,
                                  number_of_guests: ,
                                  number_of_beds: ,
                                  number_of_rooms: ,
                                  description: ,
                                  price_per_night: ,
                                  address: ,
                                  city: ,
                                  state: ,
                                  zip: ,
                                  lat: ,
                                  lat: ,
                                  long: ,
                                  image_url: ,
                                  check_in_time: ,
                                  check_out_time: ,
                                  status:

      )
  end

end

Seed.new
