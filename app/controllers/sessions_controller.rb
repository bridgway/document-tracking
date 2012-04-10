class SessionsController < ApplicationController
  def new
    if current_user
      redirect_to root_url
    end
  end

  def create
    user = User.find_by_email(params[:email]).try(:authenticate, params[:password])
    if user
      session[:user_id] = user.id
      redirect_to '/', :notice => "You're signed in."
    else
      flash.now[:notice] = "Invalid email or password"
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end
end
