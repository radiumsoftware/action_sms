module ActionSms
  class Message
    attr_accessor :to, :from, :text, :gateway_response
    attr_reader :gateway

    # Creates a new message and sets it's gateway. This *does not send the message.* 
    #
    # Options:
    # :to:: phone number to send to in internaltional form, ex: 12023838754
    # :from:: text or number to set from to. This may be dependant on the gateway.
    # :message:: text to send.
    # :gateway:: country code used to select the gateway. Ex: :gateway => :fi
    def initialize(options = {})
      options.each_pair do |key, value|
        send("#{key}=", value)
      end
    end

    def gateway=(country_code)
      @gateway = Gateways::MAP[country_code]
    end

    def deliver
      gateway.deliver(self)
    end
  end
end
