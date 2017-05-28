class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:new]

  def new
    puts "NEW"
  end
end
