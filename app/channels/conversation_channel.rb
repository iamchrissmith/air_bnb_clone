class ConversationChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    # stream_from "conversation_channel_user_#{message_user.id}"
    # stream_from "conversation_channel_id_#{conversation.id}"
    stream_from "conversation_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end