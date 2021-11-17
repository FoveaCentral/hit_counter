# frozen_string_literal: true

namespace :hit_counter do
  desc 'Install HitCounter into your app.'
  task :install do
    puts 'Configuring Mongoid and installing image files...'
    full_gem_path = Gem::Specification.find_by_name('hit_counter').full_gem_path
    system "rsync -ruv #{full_gem_path}/config ."
    system "rsync -ruv #{full_gem_path}/public ."
  end
end
