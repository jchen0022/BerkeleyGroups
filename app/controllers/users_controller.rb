class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    redirect_to root_path
  end

  def dashboard
    @user = current_user
    @groups = @user.groups
  end

  def search
    @filterrific = initialize_filterrific(
      Group,
      params[:filterrific],
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
end
