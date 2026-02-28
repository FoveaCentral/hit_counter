# frozen_string_literal: true

require 'simplecov'
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'addressable/uri'
require 'mongoid'
require 'rmagick'
require 'rspec'

require 'hit_counter'

Mongoid.load! 'config/mongoid.yml', :test
Mongo::Logger.logger.level = Logger::WARN

# Stub Rails root during tests.
module Rails
  def self.root
    '.'
  end
end

require 'rake'

# load rake tasks
# https://dev.to/cassidycodes/how-to-test-rake-tasks-with-rspec-without-rails-3mhb
# rubocop:disable Style/OneClassPerFile
module TaskFormat
  # rubocop:enable Style/OneClassPerFile
  extend ActiveSupport::Concern

  included do
    let(:task_name) { self.class.top_level_description.delete_prefix('rake ') }
    let(:tasks) { Rake::Task }
    # Make the Rake task available as `task` in your examples:
    subject(:task) { tasks[task_name] }
  end
end

RSpec.configure do |config|
  config.before(:suite) do
    Dir.glob('lib/tasks/*.rake').each { |r| Rake::DefaultLoader.new.load r }
  end

  # Tag Rake specs with `:task` metadata or put them in the spec/tasks dir
  config.define_derived_metadata(file_path: %r{/spec/tasks/}) do |metadata|
    metadata[:type] = :task
  end

  config.include TaskFormat, type: :task
end

# silence output
RSpec.configure do |config|
  original_stderr = $stderr
  original_stdout = $stdout
  config.before(:all) do
    # Redirect stderr and stdout
    # rubocop:disable Style/FileOpen
    $stderr = File.open(File::NULL, 'w')
    $stdout = File.open(File::NULL, 'w')
    # rubocop:enable Style/FileOpen
  end
  config.after(:all) do
    $stderr = original_stderr
    $stdout = original_stdout
  end
end
