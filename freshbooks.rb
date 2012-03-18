require 'builder'
require 'rest-client'
require 'net/http'
require 'crack/xml'
require 'uri'

# Usage:
# f = Freshbooks.new("https://woodbridge.freshbooks.com/api/2.1/xml-in", "e4e173dbe0aa2cac2f8349ee0edde949")

class Freshbooks
  attr_accessor :url

  def initialize(url, token)
    uri = URI.parse(url)
    # freshbooks doesn't require a password for logging in, so just pass it a random one.
    userinfo = [token, ":", "X"].join
    uri_with_authentication = URI::HTTPS.build({ host: uri.host, path: uri.path, userinfo: userinfo })
    @url = uri_with_authentication.to_s
  end

  def send_request(xml)
    RestClient.post @url, xml
  end

  def build_request(method, &block)
    builder = Builder::XmlMarkup.new

    builder.instruct! :xml, :version => "1.0", :encoding => "utf-8"

    builder.request :method => method do
      yield builder if block_given?
    end

    builder.target!
  end

  def clients
    builder = build_request "client.list"

    req_xml = builder

    response = send_request req_xml

    doc = Crack::XML.parse(response)
    if doc != nil
      # the good stuff is under the request key, so let's just use that.
      doc = doc["response"]

      # the clients are nested in a weird weird way.
      # but now we have all the clients.
      clients = doc["clients"]["client"]

      # now pluck out the exact data we want from our clients.
      good = clients.map do |client|
        {
          name: [ client["first_name"], " ", client["last_name"] ].join,
          email: client["email"]
        }
      end
    else
      doc
    end
  end
end