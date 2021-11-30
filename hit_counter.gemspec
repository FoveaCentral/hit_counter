# frozen_string_literal: true

require File.expand_path 'lib/version', __dir__
Gem::Specification.new do |s|
  s.name = 'hit_counter'
  s.version = HitCounter::VERSION.dup
  s.summary = 'Ruby version of that old 90s chestnut, the web-site hit counter.'
  s.description = 'Why roast this chestnut by that open fire, you ask? Cause '\
    'thousands and thousands of Internet vets are still using the one we '\
    "wrote in PHP eons ago and we don't want to be squandering any incidental "\
    "Google juice, that's why."
  s.homepage = 'https://github.com/FoveaCentral/hit_counter'
  s.authors = ['Roderick Monje']
  s.cert_chain = ['certs/ivanoblomov.pem']
  s.signing_key = File.expand_path('~/.ssh/gem-private_key.pem') if $PROGRAM_NAME =~ /gem\z/

  s.add_development_dependency 'rake', '>= 12.3.3', '~> 13.0'
  s.add_development_dependency 'rspec', '~> 3'
  s.add_development_dependency 'rubocop', '< 1.24'
  s.add_development_dependency 'rubocop-rake', '~> 0'
  s.add_development_dependency 'rubocop-rspec', '~> 2'
  s.add_development_dependency 'simplecov', '~> 0.18'
  s.add_development_dependency 'simplecov-lcov', '~> 0.8'

  s.add_runtime_dependency 'addressable', '~> 2'
  s.add_runtime_dependency 'bson_ext', '~> 1'
  s.add_runtime_dependency 'mongoid', '~> 7'
  s.add_runtime_dependency 'rmagick', '>= 2', '< 5'

  s.files         = `git ls-files`.split "\n"
  s.require_paths = ['lib']
  s.required_ruby_version = '>= 2.5'
end
