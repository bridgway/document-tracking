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
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end
end
