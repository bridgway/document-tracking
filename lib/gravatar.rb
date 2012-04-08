module Gravatar
  def gravatar_url(email, size = nil)
    if !@gravatar_url
      hash = Digest::MD5.hexdigest email
      @gravatar_url = "http://www.gravatar.com/avatar/#{hash}"
      if size
        @gravatar_url += "?s=#{size}"
      end
    end

    @gravatar_url
  end
end