# frozen_string_literal: true

require 'bundler'
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

def load_rake_tasks
  Dir.glob("./lib/tasks/**/*.rake").each { |f| import f }
end
load_rake_tasks

if defined? Rails
  class Railtie < Rails::Railtie # override Rails to include tasks
    rake_tasks { load_rake_tasks }
  end
end

RSpec::Core::RakeTask.new(:test) do |t|
  t.pattern = 'spec/*/*_spec.rb'
  t.verbose = false
end
task default: :test
