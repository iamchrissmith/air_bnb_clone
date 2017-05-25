class PropertyAvailability < ApplicationRecord
  validates :date, presence: true
  validates_uniqueness_of :date, :scope => :property_id
  belongs_to :property

  scope :available, -> {PropertyAvailability.where(reserved?: false)}

  def self.build_avaialability_range(first_available_date, last_available_date)
    days = []
    i = 0
    num_of_days = last_available_date - first_available_date
    (num_of_days.to_i + 1).times do
      days << first_available_date + i
      i +=1
    end
    days
  end

  def self.set_availability(first_available_date, last_available_date)
    build_avaialability_range(first_available_date, last_available_date).map do |date|
      PropertyAvailability.create(date: date)
    end
  end
end
