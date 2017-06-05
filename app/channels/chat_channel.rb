class ChatChannel < ApplicationCable::Channel
  before_subscribe :check_user

  def subscribed
    group = Group.find(params[:group_id])
    chatroom = group.chatrooms.find_by(name: params[:name])
    stream_for chatroom
  end

  private

  def check_user
    user = User.find(params[:user_id])
    group = Group.find(params[:group_id])
    if not group.users.include? user
      redirect_to root_path
    end
  end
end
