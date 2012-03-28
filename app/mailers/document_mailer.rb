require 'helpers'

class DocumentMailer < ActionMailer::Base
  default from: "notifications@documents.com"

  add_template_helper Helpers

  def notify_signee(document)
    @document = document
    mail to: document.signee.email, :subject => "A document for you.", :cc => document.copied
  end

  def notify_copied(document)
    mail to: document.copied
  end
end