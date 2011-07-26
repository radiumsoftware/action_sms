require 'simplecov'
SimpleCov.start

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'action_sms'

RSpec.configure do |config|
  config.include(ActionSMS::Matchers)
end

ActionSMS::Base.perform_deliveries = true
ActionSMS::Base.delivery_method = :test
ActionSMS::Base.template_root = File.join(File.dirname(__FILE__), 'fixtures', 'templates')

RSpec.configure do |config|
  config.before(:each) do
    ActionSMS::Base.deliveries.clear
  end
end

require 'webmock/rspec'
