require 'simplecov'
SimpleCov.start

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'action_sms'

RSpec.configure do |config|
  config.include(ActionSms::Matchers)
end

ActionSms::Base.perform_deliveries = true
ActionSms::Base.delivery_method = :test
ActionSms::Base.template_root = File.join(File.dirname(__FILE__), 'fixtures', 'templates')

RSpec.configure do |config|
  config.before(:each) do
    ActionSms::Base.deliveries.clear
  end
end

require 'webmock/rspec'
