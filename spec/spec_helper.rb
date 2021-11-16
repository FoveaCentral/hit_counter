# frozen_string_literal: true

require 'simplecov'
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'addressable/uri'
require 'mongoid'
require 'RMagick'
require 'rspec'

require 'hit_counter'

Mongoid.load! 'config/mongoid.yml', :test
Mongo::Logger.logger.level = ::Logger::WARN

# Stub Rails root during tests.
module Rails
  def self.root
    '.'
  end
end
