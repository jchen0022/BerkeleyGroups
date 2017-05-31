class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :validate_user

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      @group.tasks << @task
      current_user.tasks << @task
      TasksChannel.broadcast_to(@group, {action: "create", data: @task, user: current_user}) 
      redirect_to group_path(@group)
    else
      redirect_to root_path
    end
  end

  def edit
  end

  def update
    @task = Task.find(params[:id])
    completed = params[:completed]
    if completed == "true"
      @task.update(completed: true)
      TasksChannel.broadcast_to(@group, {action: "update", update_type: "completion", completed: "true", data: @task})
      redirect_to group_path(@group)
    elsif completed == "false"
      @task.update(completed: false)
      TasksChannel.broadcast_to(@group, {action: "update", update_type: "completion", completed: "false", data: @task})
      redirect_to group_path(@group)
    else
      puts "Should not happen"
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    TasksChannel.broadcast_to(@group, {action: "destroy", data: @task})
    redirect_to group_path(@group)
  end

  private 
  
  def validate_user
    @group = Group.find(params[:group_id])
    if not @group.users.include? current_user
      redirect_to root_path
    end
  end

  def task_params
    params.require(:task).permit(:name, :description)
  end

end
