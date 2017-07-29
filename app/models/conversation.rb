class Conversation < ApplicationRecord
  belongs_to :author, class_name: 'User'
  belongs_to :receiver, class_name: 'User'

  validates :author, uniqueness: {scope: :receiver}
  has_many :messages, -> { order(created_at: :asc) }, dependent: :destroy

  scope :participating, -> (user) do
    where("(conversations.author_id = ? OR conversations.receiver_id = ?)", user.id, user.id)
  end

  def date
    created_at.strftime('%d %B %Y')
  end

  def participates?(user)
    author == user || receiver == user
  end

  def self.create_trip_conversation(params)
    author = User.find(params[:reservation][:renter_id])
    receiver = User.joins(:properties)
                .joins("INNER JOIN reservations ON reservations.property_id = properties.id")
                .where("reservations.property_id = ?", params[:property_id]).first
    property = Property.joins(:reservations).find(params[:property_id])
    conversation = Conversation.where(author_id: author.id, receiver_id: receiver.id).first ||
                   Conversation.new(title: "Trip to #{property.name}.", author_id: author.id, receiver_id: receiver.id)
    conversation.save
  end
end
