# frozen_string_literal: true

require 'bundler'
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
path = File.expand_path(__dir__)
Dir.glob("#{path}/lib/tasks/**/*.rake").each { |f| import f }
RSpec::Core::RakeTask.new(:test) do |t|
  t.pattern = 'spec/*/*_spec.rb'
  t.verbose = false
end
task default: :test
