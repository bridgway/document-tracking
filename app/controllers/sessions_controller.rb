class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:email]).try(:authenticate, params[:password])
    if user
      session[:user_id] = user.id
      redirect_to '/', :notice => "You're signed in."
    else
      flash.now[:notice] = "Failed"
      render :new
    end
  end
end
