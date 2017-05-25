class PropertyAvailability < ApplicationRecord
  validates :date, presence: true
  belongs_to :property

  scope :available, -> {PropertyAvailability.where(reserved?: false)}

  def self.open_property_availabilities(date)
    where(date: date).where(reserved?: false)
  end

  def self.find_available_properties(date)
    open_property_availabilities(date).map do |pa|
      pa.property
    end
  end
end
