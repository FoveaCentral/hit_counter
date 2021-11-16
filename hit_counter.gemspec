require File.expand_path '../lib/version', __FILE__
Gem::Specification.new do |s|
  s.name = 'hit_counter'
  s.version = HitCounter::VERSION.dup
  s.summary = 'Ruby version of that old 90s chestnut, the web-site hit counter.'
  s.description = 'Why roast this chestnut by that open fire, you ask? Cause '\
    'thousands and thousands of Internet vets are still using the one we '\
    "wrote in PHP eons ago and we don't want to be squandering any incidental "\
    "Google juice, that's why."
  s.homepage = 'https://github.com/ivanoblomov/hit_counter'
  s.authors = ['Roderick Monje']

  s.add_development_dependency 'coveralls', '>= 0'
  s.add_development_dependency 'rake', '>= 0'
  s.add_development_dependency 'rspec', '>= 0'
  s.add_development_dependency 'rubocop', '>= 0'

  s.add_runtime_dependency 'addressable', '>= 0'
  s.add_runtime_dependency 'bson_ext', '>= 0'
  s.add_runtime_dependency 'mongoid', '~> 6'
  s.add_runtime_dependency 'rmagick', '~> 2'

  s.files         = `git ls-files`.split "\n"
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split "\n"
  s.executables   = `git ls-files -- bin/*`.split("\n")
                                           .map { |f| File.basename f }
  s.require_paths = ['lib']
end
