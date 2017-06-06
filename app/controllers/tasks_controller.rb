class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :validate_user

  def new
    @task = Task.new
  end

  def create
    to_update = task_params
    new_user = User.find(to_update.delete(:user_id))
    @task = Task.new(to_update)
    respond_to do |format|
      if @task.save
        @group.tasks << @task
        new_user.tasks << @task
        format.js 
        TasksChannel.broadcast_to(@group, {action: "create", data: @task, user: new_user}) 
      else
        @errors = @task.errors
        format.js {render :file => "layouts/errors.js.erb"}
      end
    end
  end

  def edit
    @task = Task.find(params[:id])
  rescue
      redirect_back(fallback_location: root_path)
  end

  def update
    if params.key?(:completed)
      # For updating buttons in group dashboard
      @task = Task.find(params[:id])
      @completed = params[:completed]
      if @completed == "true"
        @task.update(completed: true)
        TasksChannel.broadcast_to(@group, {action: "update", update_type: "completion", data: @task})
      elsif @completed == "false"
        @task.update(completed: false)
        TasksChannel.broadcast_to(@group, {action: "update", update_type: "completion", data: @task})
      else
        puts "Something broke at tasks#update"
      end
    else
      # For manually updating task via tasks#edit
      task = Task.find(params[:id])
      to_update = task_params
      new_user = User.find(to_update.delete(:user_id))
      respond_to do |format|
        if task.update(to_update)
          new_user.tasks << task
          format.js
          TasksChannel.broadcast_to(@group, {action: "update", update_type: "all", data: task, user: new_user})
        else
          @errors = @task.errors
          format.js {render :file => "layouts/errors.js.erb"}
        end
      end
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    TasksChannel.broadcast_to(@group, {action: "destroy", data: @task})
  end

  private 
  
  def validate_user
    @group = Group.find(params[:group_id])
    if not @group.users.include? current_user
      redirect_to root_path
    end
  end

  def task_params
    params.require(:task).permit(:name, :description, :priority, :user_id)
  end

end
