class RequestsController < ApplicationController
  before_action :authenticate_user!

  def new 
    @user = current_user
    @group = Group.find(params[:group_id])
    @users = @group.users
    @requested = params[:requested]

    if @requested == "false"
      @requested = false
    else
      @requested = true
    end
  end

  def create
    group = Group.find(params[:group_id])
    user = current_user
    request = Request.new(request_params)

    requested = false
    requests = user.requests
    requests.each do |request|
      if request.group == group
        requested = true
      end
    end
    
    # Send alert when successfully made request or an error occured
    if not requested
      respond_to do |format|
        if request.save
          group.requests << request
          user.requests << request
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

  private

  def request_params
    params.require(:request).permit(:description)
  end

end
