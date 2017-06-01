class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :in_group?, only: [:show]

  def show
    @user = current_user
    @group = current_group
    @users = current_group.users
    @tasks = @group.tasks
    @requests = @group.requests
    gon.user_id = current_user.id
    gon.group_id = @group.id
    @requested = false
    if not @in_group
      @requests.each do |request|
        if request.user == @user
          @requested = true
        end
      end
    end
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    if @group.save
      current_user.groups << @group
      redirect_to root_path
    else
      puts "Group not created"
      redirect_to root_path
    end
  end

  def search
    @filterrific = initialize_filterrific(
      Group,
      params[:filterrific],
      select_options: {
        group_size: Group.options_for_size
      }
    ) or return
    
    @groups = @filterrific.find

    respond_to do |format|
      format.html
      format.js
    end

  rescue ActiveRecord::RecordNotFound => e
    # There is an issue with the persisted param_set. Reset it.
    puts "Had to reset filterrific params: #{ e.message }"
    redirect_to(reset_filterrific_url(format: :html)) and return
  end

  def request_join
    @group = Group.find(params[:id])
    @user = User.find(params[:user_id])
    request = Request.new(request_params)
    
    # Send alert when successfully made request or an error occured
    if request.save
      @group.requests << request
      @user.requests << request
    else
      puts "Something went wrong"
    end
    redirect_to search_groups_path
  end

  def add_member
    user = User.find(params[:user_id])
    group = Group.find(params[:id])
    request = Request.find(params[:request_id])
    if group.users.length < group.size
      group.users << user 
      request.destroy
      puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    else
      puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
      puts "Group is full"
    end
    redirect_to group_path(group)
  end

  private
  
  def in_group?
    if not current_group
      redirect_back fallback_location: root_path
    else
      @in_group = current_group.users.include? current_user
    end
  end

  def current_group
    Group.find(params[:id])
  rescue 
    false
  end

  def group_params
    params.require(:group).permit(:name, :course, :size)
  end

  def request_params
    params.require(:request_join).permit(:description)
  end

end
