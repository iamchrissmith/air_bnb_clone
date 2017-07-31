class User::MessagesController < ApplicationController
  before_action :set_conversation

  def create
    message = @conversation.messages.build(message_params)
    message.user_id = current_user.id
    # message.save
    # redirect_to user_conversation_path(@conversation)
    if message.save
      ActionCable.server.broadcast 'conversation_channel',
                                   content:  message.content,
                                   username: message.user.username
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end

  def set_conversation
    @conversation = Conversation.find_by(id: params[:conversation_id])
    redirect_to(root_path) and return unless @conversation && @conversation.participates?(current_user)
  end
end