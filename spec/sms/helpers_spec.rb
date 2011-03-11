require 'spec_helper'

class HelperTestSubject
  include SMS::Helpers
end

describe SMS::Helpers do
  subject { HelperTestSubject.new }

  let(:message) {
    mock(SMS::Message, :to => '1234', :from => '5678', :text => 'example')
  }

  before(:each) do
    SMS.deliveries.clear
    SMS.deliveries << message
  end

  describe '#sms_messages' do
    it 'should return the SMS.deliveries array' do
      subject.sms_messages.should eql([message])
    end
  end

  describe '#current_sms_message' do
    it "should return the last item in the array" do
      subject.current_sms_message.should eql(message)
    end
  end

  describe '#sms_messages_sent_to' do
    it "should match the to number" do
      subject.sms_messages_sent_to('1234').should eql([message])
    end
  end

  describe '#sms_messages_sent_from' do
    it "should match the from number" do
      subject.sms_messages_sent_from('5678').should eql([message])
    end
  end

  describe '#reset_sms_messages' do
    it "should set the deliveries to an empty array" do
      subject.sms_messages.should_not be_empty
      subject.reset_sms_messages
      subject.sms_messages.should be_empty
    end
  end
end
