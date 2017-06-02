class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :in_group?, only: [:show]

  def show
    @user = current_user
    @group = current_group
    @users = current_group.users
    @tasks = @group.tasks
    gon.user_id = current_user.id
    gon.group_id = @group.id

    if not @in_group
      @requested = false
      @requests = @user.requests
      @requests.each do |request|
        if request.group == @group
          @requested = true
        end
      end
    else 
      @requests = @group.requests
    end
  end

  def new
    @user = current_user
    @group = Group.new
  end

  def create
    @user = current_user
    if current_user.groups.length < User.max_groups
      respond_to do |format|
        @group = Group.new(group_params)
        if @group.save
          @user.groups << @group
          format.html {redirect_to @group}
        else
          @errors = @group.errors
          format.js {render :file => "layouts/errors.js.erb"}
        end
      end
    else
      puts "User already has maximum number of groups"
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

    @requested = false
    @requests = @user.requests
    @requests.each do |request|
      if request.group == @group
        @requested = true
      end
    end
    
    # Send alert when successfully made request or an error occured
    if not @requested
      respond_to do |format|
        if request.save
          @group.requests << request
          @user.requests << request
          format.html {redirect_to search_groups_path}
        else
          @errors = request.errors
          format.js {render :file => "layouts/errors.js.erb"}
        end
      end
    else
      puts "Error: Trying to make another request when one already exists"
    end
  end

  def add_member
    user = User.find(params[:user_id])
    group = Group.find(params[:id])
    request = Request.find(params[:request_id])
    if not group.users.include? user
      if group.users.length < group.size
        group.users << user 
        request.destroy
      else
        puts "Group is full"
      end
    else
      puts "User already in group. Should not happen"
    end
    redirect_to group_path(group)
  end

  private
  
  def in_group?
    if not current_group
      # The group does not exist
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
