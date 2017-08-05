class Seed
  attr_reader :start_date, :end_date

  def initialize
    @start_date = DateTime.new(2017,8,1)
    @end_date = start_date + 1.month

    destroy_models
    generate_users
    generate_admin
    generate_room_types
    generate_properties_for_users
    generate_property_availability
    # generate_reservations_for_users
  end

  def destroy_models
    User.destroy_all
    RoomType.destroy_all
    Property.destroy_all
    Reservation.destroy_all
    Conversation.destroy_all
    Message.destroy_all
  end

  def generate_users
    200.times do |i|
      User.create!(
        username: "username#{i}",
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

  def generate_admin
    User.create!(
      username: "Admin",
      email: "admin@gmail.com",
      first_name: "Neil",
      last_name: "Diamond",
      image_url: "images/niel_diamond.jpg",
      phone_number: "555-555-555",
      description: "Hands, touching hands, reaching out, touching me, touching you.",
      hometown: "Brooklyn",
      role: 1,
      active?: true,
      password: "password" )
    puts "Admin created"
  end

  def generate_room_types
    RoomType.create(name: 0)
    RoomType.create(name: 1)
    RoomType.create(name: 2)

    puts "Generated #{RoomType.count} Rooms Types"
  end

  def generate_properties_for_users

    user_count = User.count
    n = 1

    CSV.foreach("db/sample_target_addresses.csv", {:headers => true, :header_converters => :symbol}) do |row|
      number_of_guests = rand(1..10)
      user = User.order("RANDOM()").last

      prop = Property.create!(
        name: Faker::Company.name,
        number_of_guests: number_of_guests,
        number_of_beds: number_of_guests / 2,
        number_of_rooms: (number_of_guests / 2.5).ceil,
        number_of_bathrooms: number_of_guests / 3,
        description: Faker::Hipster.paragraph,
        price_per_night: Faker::Commerce.price,
        address: row[:street_address],
        city: row[:city],
        state: row[:state],
        zip: row[:zip],
        image_url: images.sample,
        status: 1,
        room_type_id: RoomType.order("RANDOM()").first.id,
        check_in_time: "14:00:00",
        check_out_time: "11:00:00",
        owner_id: user.id )

      puts "#{row} property created for user_id: #{user.id}"
    end
  end

  def generate_property_availability
    properties = Property.near('Denver, Co', 100)
    properties.each do |property|
      property.property_availabilities << PropertyAvailability.set_availability(start_date, end_date)
      printf("\rProperty Availabilities: %d", PropertyAvailability.count)
    end
    puts ""
  end

  def generate_reservations_for_users
    100.times do |i|
      user = User.order("RANDOM()").last

      guests = rand(1..10)

      length_of_stay = rand(1..5)
      check_in = start_date + rand(15).day
      check_out = check_in + length_of_stay.day

      params = { dates: "#{check_in.strftime("%m/%d/%Y")}-#{check_out.strftime("%m/%d/%Y")}", guests: guests }

      property = Property.search(params).first
      break unless property
      total = (property.price_per_night * length_of_stay)

      user.reservations.create!(
        total_price: total,
        start_date: check_in,
        end_date: check_out,
        number_of_guests: Random.new.rand(1..5),
        property_id: property.id,
        renter_id: user.id,
        status: Random.new.rand(0..2) )
      puts "#{i} reservation created"
      generate_conversation(user, property)
      puts "#{i} conversation set"
    end
    puts "#{PropertyAvailability.available.count} Days Reserved"
  end

  def generate_conversation(user, property)
    host = property.owner
    conversation = Conversation.find_by(author_id: user.id, receiver_id: host.id) ||
                   Conversation.find_by(author_id: host.id, receiver_id: user.id)
    if conversation
      conversation.title = "Trip to #{property.name}."
      conversation.save
    else
      conversation = Conversation.find_or_create_by(author_id: host.id, receiver_id: user.id)
      generate_messages(conversation)
    end
  end

  def generate_messages(conversation)
    3.times do |n|
      Message.create!(
        content: "Hi, I am the visitor. This is message number #{n}.",
        conversation_id: conversation.id,
        user_id: conversation.author_id
        )
      Message.create!(
        content: "Hi, I am the property owner. This is message number #{n}.",
        conversation_id: conversation.id,
        user_id: conversation.receiver_id
        )
    end
  end

  def images
    [ "http://clv.h-cdn.co/assets/cm/15/09/54eb98794d090_-_windriver-house.jpg",
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
      "http://www.letthedogin.com/wp-content/uploads/2012/09/DSC_0107.jpg" ]
  end

end

Seed.new