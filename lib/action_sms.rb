require 'yaml'

module ActionSMS
  # Rasised when a gateway has problems. The gateway fills it in.
  class GatewayError < StandardError; end

  class Gateway
    def self.config
      ActionSMS::Base.gateway_configuration[self.to_s.split('::').last.downcase]
    end
  end

  autoload :Message, 'action_sms/message'
end

require 'action_sms/base'
require 'action_sms/gateways'
require 'action_sms/helpers'
require 'action_sms/matchers'
