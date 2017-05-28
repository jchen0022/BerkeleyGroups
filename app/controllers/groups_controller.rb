class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :in_group?

  def show
    @group = current_group
    @users = current_group.users
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

end
