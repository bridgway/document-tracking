class DocumentsController < ApplicationController
  def index
    @user = current_user
    @unsigned = @user.unsigned_documents
    @signed = @user.unsigned_documents
  end
end
