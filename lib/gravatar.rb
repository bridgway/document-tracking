module Gravatar
  def gravatar_url(email)
    if !@gravatar_url
      hash = Digest::MD5.hexdigest email
      @gravatar_url = "http://www.gravatar.com/avatar/#{hash}"
    end

    @gravatar_url
  end
end