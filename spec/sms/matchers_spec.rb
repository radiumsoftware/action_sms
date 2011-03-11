require 'spec_helper'

describe SMS::Matchers do
  subject { mock(SMS::Message, :to => '1234', :from => '5678', :text => 'example') }

  it { should send_to('1234') }
  it { should_not send_to('123489791238') }
  it { should be_sent_to('1234') }
  it { should_not be_sent_to('2138497') }

  it { lambda { should send_to('1234899')}.should raise_error }
  it { lambda { should_not send_to('1234')}.should raise_error }

  it { should send_from('5678') }
  it { should_not send_from('123489723') }
  it { should be_sent_from('5678') }
  it { should_not be_sent_from('123489723') }

  it { lambda { should send_from('1234899')}.should raise_error }
  it { lambda { should_not send_from('5678')}.should raise_error }
end
