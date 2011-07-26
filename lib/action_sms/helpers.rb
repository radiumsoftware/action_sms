module ActionSms
  module Helpers
    def current_sms_message
      sms_messages.last
    end

    def sms_messages
      ActionSms::Base.deliveries
    end

    def sms_messages_sent_to(to)
      sms_messages.select {|message| message.to.eql?(to)}
    end

    def sms_messages_sent_from(from)
      sms_messages.select {|message| message.from.eql?(from)}
    end

    def reset_sms_messages
      sms_messages.clear
    end
  end
end
