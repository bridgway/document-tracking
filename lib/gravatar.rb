module Gravatar
  def gravatar
    if !@gravatar_url
      email = self.source.email
      hash = Digest::MD5.hexdigest email
      @gravatar_url = "http://www.gravatar.com/avatar/#{hash}"
    end

    @gravatar_url
  end
end