class DocumentMailer < ActionMailer::Base
  def test
    mail(:to => "test@me.com", :from => "test@me.com")
  end
end