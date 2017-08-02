module ConversationHelper

  def set_conversation(reservation)
    owner = reservation.property.owner
    renter = current_user
    Conversation.find_by(author_id: renter.id, receiver_id: owner.id) ||
      Conversation.find_by(author_id: owner.id, receiver_id: renter.id)
  end
end