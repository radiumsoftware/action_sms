require 'spec_helper'

describe ActionSms::Gateways::Labyrintti do
  before(:each) do
    ActionSms.configuration = {
      'labyrintti' => {'user' => 'user', 'password' => 'password'}
    }
  end

  subject { ActionSms::Gateways::Labyrintti }

  let(:message) do
    mock(ActionSms::Message, :to => '1234', :from => '5678', :text => 'hi').as_null_object
  end

  it "should do a post to the gateway url" do
    stub_request(:post, 'http://gw.labyrintti.com:28080/sendsms').
      with(:body => {
        :user => 'user', :password => 'password',
        :text => 'hi', :dests => '1234', 'source-name' => '5678'
      }, :content_type => 'application/x-www-form-urlencoded'
      ).to_return(:body => 'OK')

    subject.deliver(message)
  end

  it "should store the gateway response for logging purposes" do
    stub_request(:post, 'http://gw.labyrintti.com:28080/sendsms').
      to_return(:body => 'OK: this is a response!')

    message.should_receive(:gateway_response=).with('OK: this is a response!')
    subject.deliver(message)
  end

  it "should raise an error if the gateway returns an error" do
    stub_request(:post, 'http://gw.labyrintti.com:28080/sendsms').
      to_return(:body => 'ERROR: error description')

    lambda { subject.deliver(message) }.should raise_error(ActionSms::GatewayError)
  end

  it "should raise an error if the gateway returns an unknown format" do
    stub_request(:post, 'http://gw.labyrintti.com:28080/sendsms').
      to_return(:body => 'somtimes these things happen')

    lambda { subject.deliver(message) }.should raise_error(ActionSms::GatewayError)
  end
end
