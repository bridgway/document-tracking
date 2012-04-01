class ApplicationController < ActionController::Base
  protect_from_forgery

  def current_user
    if session[:user_id]
      @current_user ||= User.find(session[:user_id])
    end
  end

  # Don't send sensitive information to the client.
  def client_side_current_user
    if session[:user_id]
      User.select([:first_name, :last_name, :email]).find session[:user_id]
    end
  end

  def logged_in?
    session[:user_id] != nil
  end

  def authenticate!
    unless self.current_user != nil
      redirect_to login_path, :notice => "Please sign in."
    end
  end

  def not_found
    render :file => "public/404.html", :status => 404, :layout => false
  end

  helper_method :current_user
end
