# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "sms/version"

Gem::Specification.new do |s|
  s.name        = "sms"
  s.version     = Sms::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Adam Hawkins"]
  s.email       = ["adam@radiumcrm.com"]
  s.homepage    = ""
  s.summary     = %q{SMS Delivery System}
  s.description = %q{Delivery sms to any country using region specific gateways}

  s.rubyforge_project = "sms"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'webmock'
  s.add_development_dependency 'infinity_test'
end
