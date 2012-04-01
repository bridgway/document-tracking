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
    mail to: document.signee.email, :subject => "A document for you.", :cc => document.copied
  end
end