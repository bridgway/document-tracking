class UsersController < ApplicationController
  before_filter :authenticate!

  def show
    redirect_to user_documents_url current_user
  end
end
