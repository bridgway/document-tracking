class DocumentsController < ApplicationController
  before_filter :authenticate!

  def index
    @user = current_user
    @unsigned = @user.unsigned_documents
    @signed = @user.signed_documents
  end

  def show
    @document = current_user.documents.find params[:id]
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
      # DocumentMailer.notify_signee(doc).deliver

      event = {
        :timestamp => DateTime.now,
        :text => "Document was emailed to recipients."
      }

      doc.events << event
      doc.save

      # TODO: I need to make a consistent module with helpers for generating urls.
      redirect_to document_url(doc)
    else
      flash[:error] = "Something went wrong.  We are working on it."
      redirect_to '/'
    end
  end
end
