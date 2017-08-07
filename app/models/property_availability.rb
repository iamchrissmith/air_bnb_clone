class PropertyAvailability < ApplicationRecord
  validates :date, presence: true
  validates_uniqueness_of :date, :scope => :property_id
  belongs_to :property

  scope :available, -> {where(reserved: false)}

  def self.set_availability(first_available_date, last_available_date)
    (first_available_date..last_available_date).map do |date|
      PropertyAvailability.create(date: date)
    end
  end

  def self.set_reserved(property_id, check_in, check_out)
    property = Property.find(property_id)
    availabilities = property.property_availabilities.where(:property_availabilities => { date: check_in..check_out })
    availabilities.map do |avail|
      avail.update(reserved: true)
      avail.save
    end
  end
end
