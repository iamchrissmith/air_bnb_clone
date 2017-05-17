class RoomType < ApplicationRecord
  has_many :properties

  enum name: %w(Shared\ Room Private\ Room Entire\ House)
end
