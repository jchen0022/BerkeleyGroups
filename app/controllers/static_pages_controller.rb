class StaticPagesController < ApplicationController
  def home
  end

  def search
    redirect_to root_path
  end
end
