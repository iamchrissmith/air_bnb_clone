class PropertyAvailability < ApplicationRecord
  validates :date, presence: true
  belongs_to :property
end
