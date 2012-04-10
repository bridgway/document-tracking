class UsersController < ApplicationController
  before_filter :authenticate!, :except => [:new, :create]
  respond_to :html, :json

  def new
    redirect_to root_url if current_user
  end

  def show
    redirect_to user_documents_url current_user
  end

  def create
    names = params[:user][:name].split ' '

    params[:user].delete :name

    @user = User.new params[:user]
    @user.first_name = names.first
    @user.last_name = names.last

    if @user.save
      session[:user_id] = @user.id
    end

    respond_with @user
  end

  def clear_activity
    if current_user.clear_document_activity
      render :json => "OK"
    else
      render :json => "ERROR"
    end
  end
end
