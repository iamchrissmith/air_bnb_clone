class User::ConversationsController < ApplicationController
  def index
    @conversations = current_user.conversations
  end

  def show
    @conversation = current_user.conversations.includes(:messages).find(params[:id])
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