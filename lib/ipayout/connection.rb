require 'faraday'
require 'faraday/mashify'
require 'ipayout/core_ext/hash'
require 'ipayout/response/raise_client_error'
require 'ipayout/response/raise_server_error'
require 'ipayout/config'

module Ipayout
  module Connection
    private

    # Returns a Faraday::Connection object
    # rubocop:disable MethodComplexity
    def connection
      default_options = {
        headers: {
          accept: 'application/json',
          user_agent: user_agent
        },
        ssl: { verify: false }
      }

      faraday_options = connection_options.deep_merge(default_options)
      faraday_options['url'] = Ipayout.configuration.endpoint
      faraday_options['proxy'] = Ipayout.configuration.proxy

      Faraday.new(url: faraday_options['url'], proxy: faraday_options['proxy']) do |faraday|
        faraday.request :url_encoded
        faraday.response :raise_error
        faraday.use Ipayout::Response::RaiseClientError
        faraday.use Ipayout::Response::RaiseServerError
        faraday.response :mashify
        faraday.response :json, content_type: [/.*/]
        faraday.adapter Faraday.default_adapter
      end
    end
  end
end
