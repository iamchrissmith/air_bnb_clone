class PropertyAvailability < ApplicationRecord
  validates :date, presence: true
  validates_uniqueness_of :date, :scope => :property_id
  belongs_to :property

  scope :available, -> {PropertyAvailability.where(reserved?: false)}

  def self.set_availability(first_available_date, last_available_date)
    (first_available_date..last_available_date).map do |date|
      PropertyAvailability.create(date: date)
    end
  end
end
