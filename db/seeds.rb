
class Seed

  def initialize
    generate_users
    generate_room_types
    generate_properties_for_users
    generate_reservations_for_users
  end

  def generate_users
    1000.times do |i|
      User.create!(
        email: Faker::Internet.email,
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name,
        image_url: Faker::Avatar.image,
        phone_number: Faker::PhoneNumber.cell_phone,
        description: Faker::Lorem.paragraph,
        hometown: Faker::Address.city,
        role: 0,
        active?: true,
        password: "password"
        )
      puts "#{i} user created"
    end
  end

  def generate_room_types
    RoomType.create(name: 0)
    RoomType.create(name: 1)
    RoomType.create(name: 2)
  end

  def generate_properties_for_users
    images = ["http://clv.h-cdn.co/assets/cm/15/09/54eb98794d090_-_windriver-house.jpg",
      "https://upload.wikimedia.org/wikipedia/commons/1/15/Castel_Telvana_Borgo.jpg",
      "http://media.architecturaldigest.com/photos/58051ed2cdff3c07101dee82/master/pass/matthew-mcconaughey-airstream-trailer-10.jpg",
      "http://modelosdefachadasdecasas.com/wp-content/uploads/2015/11/modelo-fachada-de-casas-bonitas.jpg",
      "http://www.yurts.com/wp-content/uploads/2015/07/24-Pacific-Yurt-With-Picnic-Table.jpg",
      "http://www.newyorker.com/wp-content/uploads/2016/04/Manley-SoYoureaDudeWhoWantstoBuildaTreeHouse-1200.jpg",
      "https://static.independent.co.uk/s3fs-public/thumbnails/image/2016/01/21/12/treehouse-thailand.jpg",
      "http://hgtvhome.sndimg.com/content/dam/images/hgtv/fullset/2013/5/1/0/RX-HGMAG011_Brooks-Beachhouse-135-b-4x3.jpg.rend.hgtvcom.1280.960.jpeg",
      "https://assets.bwbx.io/images/users/iqjWHBFdfxIU/iGLAXAV9HfdY/v0/1200x750.jpg",
      "https://www.mohonk.com/wp-content/uploads/2017/01/Fact-Sheets-1680x1260.jpg",
      "http://jjtravels.net/wp-content/uploads/2009/10/IMG_3705.JPG",
      "http://www.letthedogin.com/wp-content/uploads/2012/09/DSC_0107.jpg"]

    CSV.foreach("db/sample_target_addresses.csv", {:headers => true, :header_converters => :symbol}) do |row|
      num = Random.new.rand(1..10)
      user = User.find(Random.new.rand(1..1000))
      user.properties.create!(
        name: Faker::Company.name,
        number_of_guests: (num * 2),
        number_of_beds: (num + 2),
        number_of_rooms: num,
        number_of_bathrooms: num,
        description: Faker::Hipster.paragraph,
        price_per_night: Faker::Commerce.price,
        address: row[:street_address],
        city: row[:city],
        state: row[:state],
        zip: row[:zip],
        lat: row[:latitude],
        long: row[:longitude],
        image_url: images.sample,
        status: 1,
        room_type_id: Random.new.rand(1..3),
        check_in_time: "14:00:00",
        check_out_time: "11:00:00"
        )
      puts "#{row} property created"
    end
  end

  def generate_reservations_for_users
    500.times do |i|
      user = User.find(Random.new.rand(1..User.count))
      property = Property.find(Random.new.rand(1..Property.count))
      length_of_stay = Random.new.rand(1..5)
      total = (property.price_per_night * length_of_stay)
      begin_date = Faker::Date.forward(23)
      user.reservations.create!(
        total_price: total,
        start_date: begin_date,
        end_date: begin_date + Random.new.rand(1..10),
        number_of_guests: Random.new.rand(1..5),
        property_id: property.id,
        renter_id: user.id,
        status: Random.new.rand(0..2)
        )
      puts "#{i} reservation created"
    end
  end
end

Seed.new
