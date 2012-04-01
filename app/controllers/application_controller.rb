class ApplicationController < ActionController::Base
  protect_from_forgery

  def current_user
    # TODO: Cache this in a an instance variable
    User.where(id: session[:user_id]).first
  end

  def logged_in?
    session[:user_id] != nil
  end

  helper_method :current_user
end
