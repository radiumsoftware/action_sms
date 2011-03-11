module SMS
  module Matchers

    class SendTo
      def initialize(expected_number)
        @expected_number = expected_number
      end

      def description
        "be sent to #{@expected_number.inspect}"
      end

      def matches?(message)
        @message = message
        @actual_number = @message.to
        @actual_number == @expected_number
      end

      def failure_message
        "expected #{@message.inspect} to deliver to #{@expected_number.inspect}, but it delivered to #{@actual_number.inspect}"
      end

      def negative_failure_message
        "expected #{@message.inspect} to not deliver to #{@expected_number.inspect}, but it delivered to #{@actual_number.inspect}, but it did"
      end
    end

    def send_to(expected)
      SendTo.new(expected)
    end

    alias :be_sent_to :send_to


    class SendFrom
      def initialize(expected_number)
        @expected_number = expected_number
      end

      def description
        "be sent from #{@expected_number.inspect}"
      end

      def matches?(message)
        @message = message
        @actual_number = @message.from
        @actual_number == @expected_number
      end

      def failure_message
        "expected #{@message.inspect} from deliver from #{@expected_number.inspect}, but it delivered from #{@actual_number.inspect}"
      end

      def negative_failure_message
        "expected #{@message.inspect} from not deliver from #{@expected_number.inspect}, but it delivered from #{@actual_number.inspect}, but it did"
      end
    end

    def send_from(expected)
      SendFrom.new(expected)
    end

    alias :be_sent_from :send_from
  end
end

