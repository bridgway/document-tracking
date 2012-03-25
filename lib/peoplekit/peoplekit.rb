$:.unshift File.join(File.dirname(__FILE__), "peoplekit")

require "version"
require "freshbooks_client"
require "harvest_client"

module PeopleKit
  def self.connect(type, opts = {})
    case type
    when :freshbooks
      FreshbooksClient.new opts[:url], opts[:token]
    when :harvest
      HarvestClient.new opts[:subdomain], opts[:username], opts[:password]
    end
  end
end
