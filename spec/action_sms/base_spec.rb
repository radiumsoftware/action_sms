require 'spec_helper'

class SmsMan < ActionSMS::Base
  def simple_message
    to '1234-567'
    from '567-8910'
    message 'content predefined'
  end

  def with_template_required
    to '1234-567'
    from '567-8910'
  end

  def with_template_variables
    to '1234-567'
    from '567'
    message :text => 'Template instance variable'
  end

  def with_generated_url
    to '1234-567'
    from '567-8910'
  end
end

describe ActionSMS::Base do
  subject { SmsMan }

  it "should be able to build new messages" do
    sms = SmsMan.create_simple_message
    sms.to.should eql('1234-567')
    sms.from.should eql('567-8910')
    sms.text.should eql('content predefined')
  end

  it "should be able to render templates" do
    sms = SmsMan.create_with_template_required
    sms.text.strip.should eql('Hi')
  end

  it "should be able to pass variables to the template" do
    sms = SmsMan.create_with_template_variables
    sms.text.should include('Template instance variable')
  end
end
