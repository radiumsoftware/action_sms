module ActionSMS
  class Message
    class UnsupportedRegion < RuntimeError ; end
    attr_accessor :to, :from, :text, :gateway_response

    # Creates a new message and sets it's gateway. This *does not send the message.* 
    #
    # Options:
    # :to:: phone number to send to in internaltional form, ex: 12023838754
    # :from:: text or number to set from to. This may be dependant on the gateway.
    # :message:: text to send.
    def initialize(options = {})
      options.each_pair do |key, value|
        send("#{key}=", value)
      end
    end

    def gateway
      country_code = to.match(/^\+?(\d{3})/)[1]
      Gateways::MAP[country_code]
    end

    def deliver
      raise UnsupportedRegion unless gateway
      gateway.deliver(self)
    end
  end
end
