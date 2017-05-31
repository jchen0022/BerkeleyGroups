class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    redirect_to root_path
  end

  def dashboard
    @user = current_user
    @groups = @user.groups
  end

end
