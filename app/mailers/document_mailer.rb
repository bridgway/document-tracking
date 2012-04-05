class DocumentMailer < ActionMailer::Base
  default from: "notifications@documents.com"

  def public_discussion_url(user, document, opts = {})
    transfer = document.transfer
    url = File.join(user.id.to_s, "view", document.slug)
    if opts[:token]
      url << "?token=#{transfer.view_token}"
    end
    url
  end

  def notify_signee(document)
    @document = document

    @document.recipients.each do |recipient|
      @recipient = recipient
      mail to: recipient.email, :subject => "A document for you."
    end
  end

  def notify_about_signing(document)
    @document = document
    @document.recipients.each do |recipient|
      @recipient = recipient
      mail to: @recipient.email, subject: "The document was signed"
    end
  end
end