class TasksChannel < ApplicationCable::Channel
  def subscribed
    user = User.find(params[:user_id])
    group = Group.find(params[:group_id])
    stream_for group
  end
end
