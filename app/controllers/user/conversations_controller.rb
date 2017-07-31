class User::ConversationsController < ApplicationController
  before_action :set_conversation, only: [:show]
  before_action :check_participating!, only: [:show]

  def index
    @conversations = Conversation.participating(current_user)
  end

  def show
  end

  def create
    conversation = Conversation.message_host(current_user, params)
    binding.pry
    redirect_to user_conversation_path(conversation)
  end

  private
    def conversation_params
      params.require(:conversation).permit(:title)
    end

    def set_conversation
      @conversation = Conversation.participating(current_user).find(params[:id])
    end

    def check_participating!
      redirect_to root_path unless @conversation && @conversation.participates?(current_user)
    end
end