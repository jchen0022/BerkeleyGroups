class ChatroomsController < ApplicationController
  before_action :authenticate_user!
  before_action :current_group_and_chatroom
  before_action :check_user

  def create_message
    message = ChatMessage.new(message_params)
    if message.save
      @chatroom.chat_messages << message
      current_user.chat_messages << message
      ChatChannel.broadcast_to(@chatroom, message: message, user: current_user) 
    end
  end

  private 

  def check_user
    if not @group.users.include? current_user
      redirect_to root_path
    end
  end

  def current_group_and_chatroom
    @group = Group.find(params[:group_id])
    @chatroom = @group.chatrooms.find(params[:id])
    if not @chatroom
      redirect_to root_path
      puts "Something went wrong in chatrooms#current_group_and_chat_room"
    end
  end

  def message_params
    params.require(:chat_message).permit(:message)
  end
end
