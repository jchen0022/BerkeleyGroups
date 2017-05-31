class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :in_group?, only: [:show]

  def show
    @group = current_group
    @users = current_group.users
    @tasks = @group.tasks
    gon.user_id = current_user.id
    gon.group_id = @group.id
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

end
