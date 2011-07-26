class SmsMan < ActionSMS::Base
  def with_generated_url
    to '1234-567'
    from '567-8910'
  end
end

describe 'Generating urls' do
  it "should use ActionMailer for URL options" do
    ActionMailer::Base.default_url_options[:host] = 'example.com'
    ActionSMS::Base.default_url_options.should eql(ActionMailer::Base.default_url_options)
  end

  it "should be able to generate URL's in views" do
    ActionSMS::Base.default_url_options[:host] = 'example.com'

    ActionController::Routing::Routes.draw do |map| 
      map.connect ':controller/:action' 
      map.welcome 'welcome', :controller => "foo", :action => "bar"
    end

    sms = SmsMan.create_with_generated_url
    sms.text.should include('http://example.com/posts')
    sms.text.should include('http://example.com/welcome')
  end
end
