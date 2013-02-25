$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'addressable/uri'
require 'mongoid'
require 'rmagick'
require 'rspec'

require 'hit_counter'

Mongoid.load! 'config/mongoid.yml', :test
Mongoid.logger = false

# Stub Rails root during tests.
module Rails
  def self.root
    '.'
  end
end