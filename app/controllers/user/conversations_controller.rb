class User::ConversationsController < ApplicationController
  def index

  end

  def show
    @conversation = Converation.includes(:messages).find(params[:id])
  end
end