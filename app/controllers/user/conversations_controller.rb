class User::ConversationsController < ApplicationController
  before_action :set_conversation, only: [:show]
  before_action :check_participating!, only: [:show]

  def index
    @conversations = Conversation.participating(current_user)
  end

  def show
  end

  def new
  end

  def create
    # @conversation = current_user.conversations.build(conversation_params)
    # if @conversation.save
    #   redirect_to user_conversations_path
    # else
    #   redirect_to '/'
    # end
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