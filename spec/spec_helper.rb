require 'simplecov'
SimpleCov.start

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'sms'

RSpec.configure do |config|
  config.include(SMS::Matchers)
end

require 'webmock/rspec'
