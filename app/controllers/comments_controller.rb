class CommentsController < ApplicationController
  respond_to :html, :json

  def create
    source = find_source

    @comment = source.comments.build ({
      source: source,
      document_id: params[:document_id],
      body: params[:comment][:body],
    })

    @comment.save

    respond_to do |format|
      format.json { render :json => @comment.to_json}
      format.html { redirect_to :back }
    end
  end

  private

  def find_source
    if params[:person_id]
      # a viewer sent this comment, not a user.
      Person.find(params[:person_id])
    else
      # otherwise just use the signed in account owning user.
      User.find(params[:user_id])
    end
  end
end
