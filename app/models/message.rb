class Message < ApplicationRecord
  has_many :conversations
  has_many :users, through: :conversations
  validates :content, presence: true
  # scope :for_display, -> { order(:created_at).last(50) }

  def timestamp
    created_at.strftime('%H:%M:%S %d %B %Y')
  end
end