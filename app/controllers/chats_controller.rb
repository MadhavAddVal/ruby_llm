class ChatsController < ApplicationController
  def show
    @chat = Chat.find(params[:id])
  end

  def create
    @chat = Chat.create!(
      model_id: "gpt-3.5-turbo"
    )
    redirect_to @chat
  end
end
