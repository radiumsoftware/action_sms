require 'net/http'

module ActionSMS
  module Gateways

    class Labyrintti < Gateway

      URL = "http://gw.labyrintti.com:28080/sendsms"

      def self.deliver(message)
        options = {}
        options[:user] = config['user']
        options[:password] = config['password']
        options[:text] = message.text
        options[:dests] = message.to
        options['source-name'] = message.from

        response = send_request(options)

        case response.body
        when /OK/
          # nothing sending successfull
        when /Error/i
          raise ActionSMS::GatewayError, response.body
        else raise ActionSMS::GatewayError, "Failed for an unknown reason. Gateway returned: #{response.body}"
        end

        message.gateway_response = response.body
        message
      end

      private
      def self.send_request(options) 
        url = URI.parse(URL)
        Net::HTTP.post_form(url, options)
      end
    end
  end
end

