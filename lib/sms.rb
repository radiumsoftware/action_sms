require 'yaml'

module SMS

  # Rasised when a gateway has problems. The gateway fills it in.
  class GatewayError < StandardError; end

  class Gateway
    def self.config
      SMS.config[self.to_s.split('::').last.downcase]
    end
  end

  autoload :Message, 'sms/message'

  @@deliveries = []
  @@test_mode = false

  def self.configuration=(hash)
    @@configuration = hash
  end

  def self.config
    @@configuration
  end

  def self.deliver(options)
    raise StandardError, "Must configure gateways before messages can be sent." unless SMS.config
    message = Message.new(options)
    message.deliver unless @@test_mode

    @@deliveries << message if @@test_mode
    message
  end

  def self.test_mode 
    @@test_mode
  end

  def self.test_mode=(flag)
    @@test_mode = flag
  end

  def self.deliveries
    @@deliveries
  end

  def self.deliveries=(arg)
    @@deliveries = arg
  end
end

require 'sms/gateways'
require 'sms/helpers'
require 'sms/matchers'
