class DocumentsController < ApplicationController
  before_filter :authenticate!, :only => [:index, :create]

  def index
    @user = current_user
    @unsigned = @user.unsigned_documents
    @signed = @user.signed_documents
  end


  # make this less shitty and more clear.
  def show
    # Public Show Page
    if request.url =~ /view[\?.*]?/
      @document = current_user.documents.find params[:id]

      if params[:token]
        @token = Token.find_by_code(params[:token])

        if @token
          @viewer = @token.person
        else
          not_found
          return
        end
      elsif !current_user
        not_found
        return
      end

      render :public
    # The Admin Page
    else
      @document = current_user.documents.find params[:id]
      render :show
    end
  end

  def create
    file = DocumentFile.new(:user_id => current_user.id, :source => params[:file])
    doc = Document.new message: params[:message]

    doc.file = file
    doc.user = current_user

    signee = Person.find_by_name params[:to]

    doc.signee = signee
    doc.recipients << signee

    params[:cc].split(",").map(&:strip).each do |name|
      doc.recipients << Person.find_by_name(name)
    end

    if doc.save
      DocumentMailer.notify_signee(doc).deliver

      event = {
        :timestamp => DateTime.now,
        :text => "Document was emailed to recipients."
      }

      doc.events << event
      doc.save

      # TODO: I need to make a consistent module with helpers for generating urls.
      redirect_to user_document_url(current_user, doc)
    else
      flash[:error] = "Something went wrong.  We are working on it."
      redirect_to '/'
    end
  end

  def update    
    # should find an efficient way to scope this to a more secure quer.
    @document = Document.find(params[:id])

    if @document.update_attributes(params[:document])
      redirect_to :back
    end
  end
end
