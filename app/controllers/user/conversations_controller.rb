class User::ConversationsController < ApplicationController
  def index
    @conversations = Conversation.participating(current_user)
  end

  def show
    @conversation = Conversation.participating(current_user).find(params[:id])
  end

  def new
    
  end

  def create
    @conversation = current_user.conversations.build(conversation_params)
    if @conversation.save
      redirect_to user_conversations_path
    else
      redirect_to '/'
    end
  end

  private
    def conversation_params
      params.require(:conversation).permit(:title)
    end
end