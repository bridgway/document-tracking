class ApplicationController < ActionController::Base
  protect_from_forgery

  def current_user
    if session[:user_id]
      @current_user ||= User.find(session[:user_id])
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

  helper_method :current_user
end
