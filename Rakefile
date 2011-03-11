require 'bundler'

# subclass to not push gem to gemcutter
class PrivateGemHelper < Bundler::GemHelper
  def release_gem
    guard_clean
    guard_already_tagged
    built_gem_path = build_gem
    tag_version {
      git_push
    }
  end
end
PrivateGemHelper.install_tasks

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

task :default => :spec
