class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    redirect_to root_path
  end

  def dashboard
    @user = current_user
    @groups = @user.groups
  end

  def leave_group
    @group = Group.find(params[:id])
    @group.users.delete(current_user)
    if @group.users.length == 0
      @group.destroy
    end
    redirect_to user_dashboard_path(current_user)
  end

end
