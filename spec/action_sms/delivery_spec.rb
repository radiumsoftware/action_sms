require 'spec_helper'

describe 'Sending SMS' do
  it "should deliver the message with the gateway when using http" do
    ActionSMS::Base.delivery_method = :http

    sms = SmsMan.create_simple_message

    sms.should_receive(:deliver)

    SmsMan.deliver(sms)
  end

  it "should store the messages in the deliveries array when using test mode" do
    ActionSMS::Base.delivery_method = :test

    sms = SmsMan.deliver_simple_message

    ActionSMS::Base.deliveries.should include(sms)
  end

  it "should catch raise errors when configured" do
    ActionSMS::Base.raise_delivery_errors = true
    ActionSMS::Base.delivery_method = :http

    sms = SmsMan.create_simple_message

    sms.stub(:deliver).and_raise(StandardError.new('Example error'))

    lambda { 
      SmsMan.deliver(sms)
    }.should raise_error(StandardError, 'Example error')
  end

  it "should not add deliveries to action mailer's deliveries" do
    ActionSMS::Base.deliveries << 1
    ActionMailer::Base.deliveries.should_not include(1)
  end

  it "should not use deliveries added to action mailer" do
    ActionMailer::Base.deliveries << 1
    ActionSMS::Base.deliveries.should_not include(1)
  end
end
