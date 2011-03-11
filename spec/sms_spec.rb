require 'spec_helper'

describe SMS do
  subject { SMS }

  it { should respond_to(:test_mode, :test_mode=) }
  it { should respond_to(:deliveries, :deliveries=) }

  let(:message) { mock(SMS::Message) }

  it "should be able to deliver a message" do
    options = {:these => :options}

    SMS::Message.should_receive(:new).with(options).and_return(message)
    message.should_receive(:deliver)

    subject.deliver(options)
  end

  it "should store messages when in test mode" do
    SMS.test_mode = true

    options = {:these => :options}

    SMS::Message.should_receive(:new).with(options).and_return(message)

    message.should_not_receive(:deliver)

    subject.deliver(options)

    subject.deliveries.should include(message)
  end
end
