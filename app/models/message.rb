class Message < ApplicationRecord
  belongs_to :user
  belongs_to :conversation, dependent: :destroy
  validates :content, presence: true
  # scope :for_display, -> { order(:created_at).last(50) }
end