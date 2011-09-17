$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'hit_counter'

Mongoid::Config.from_hash 'database' => 'hit_counter'
Mongoid.logger = false

# Stub Rails root during tests.
module Rails
  def self.root
    '.'
  end
end