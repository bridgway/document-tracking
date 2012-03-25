require 'rest-client'
require 'crack/xml'

module PeopleKit
  class HarvestClient
    BASE = "harvestapp.com"

    attr_accessor :subdomain, :email, :password, :api_url

    def initialize(subdomain, email, password)
      @subdomain = subdomain
      @email = email
      @password = password
      @api_url = generate_api_url
    end

    def generate_api_url
      @api_url = [@subdomain, ".", BASE].join
    end

    def people
      req = RestClient::Request.new ({
        :method => :get,
        :user => @email,
        :password => @password,
        :url => @api_url + "/contacts"
      })

      people = Crack::XML.parse req.execute
      people['contacts'].map do |person|
        name = [ person['first_name'], ' ', person['last_name'] ].join

        { email: person['email'], name: name }
      end
    end
  end
end