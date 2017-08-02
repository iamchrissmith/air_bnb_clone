class Message < ApplicationRecord
  belongs_to :user
  belongs_to :conversation
  validates :content, presence: true

  def timestamp
    created_at.strftime('%H:%M:%S %d %B %Y')
  end
end