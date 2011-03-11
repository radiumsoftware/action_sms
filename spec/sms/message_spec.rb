require 'spec_helper'

describe SMS::Message do
  describe '#initialize' do
    subject { SMS::Message.new :to => '1234', :from => '5678', :text => 'example' }

    it "should set the to number" do
      subject.to.should eql('1234')
    end

    it "should set the from number" do
      subject.from.should eql('5678')
    end

    it "should set the text" do
      subject.text.should eql('example')
    end
  end

  it "should set the gateway from the country code" do
    subject.gateway = :fi
    subject.gateway.should eql(SMS::Gateways::Labyrintti)
  end

  it "should delegate #deliver to #gateway" do
    subject.stub :gateway => mock(SMS::Gateway)
    subject.gateway.should_receive(:deliver).with(subject)
    subject.deliver
  end
end
