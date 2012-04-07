class UsersController < ApplicationController
  before_filter :authenticate!

  def show
    redirect_to user_documents_url current_user
  end

  def clear_activity
    if current_user.clear_document_activity
      render :json => "OK"
    else
      render :json => "ERROR"
    end
  end
end
