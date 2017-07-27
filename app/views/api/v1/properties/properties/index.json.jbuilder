json.properties @presenter.properties do |property|
  json.id property.id
  json.name property.name
  json.description property.description
  json.number_of_guests property.number_of_guests
  json.number_of_beds property.number_of_beds
  json.number_of_rooms property.number_of_rooms
  json.number_of_bathrooms property.number_of_bathrooms
  json.price_per_night property.price_per_night
  json.address property.address
  json.city property.city
  json.state property.state
  json.zip property.zip
  json.lat property.lat
  json.long property.long
  json.check_in_time property.check_in_time
  json.check_out_time property.check_out_time
  json.image_url url_for(property.image_url)
  json.status property.status
  json.room_type_id property.room_type_id
  json.owner_id property.owner_id
end