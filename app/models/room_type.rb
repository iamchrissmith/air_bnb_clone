class RoomType < ApplicationRecord
  validates :name, presence: true
  has_many :properties
  enum name: %w(Shared\ Room Private\ Room Entire\ House)
end
