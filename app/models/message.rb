class Message < ApplicationRecord
  belongs_to :user
  belongs_to :conversation
  validates :content, presence: true
  # scope :for_display, -> { order(:created_at).last(50) }

  def timestamp
    created_at.strftime('%H:%M:%S %d %B %Y')
  end
end