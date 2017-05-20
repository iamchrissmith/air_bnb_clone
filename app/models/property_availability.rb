class PropertyAvailability < ApplicationRecord
  validates :date, :reserved?, presence: true
  belongs_to :property
end
