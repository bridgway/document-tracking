class DocumentMailer < ActionMailer::Base
  default from: "notifications@documents.com"

  def notify_signee(document)
    mail to: document.signee.email, :subject => "A document for you."
  end

  def notify_copied(document)
    mail to: document.copied
  end
end