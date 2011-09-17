namespace :hit_counter do
  desc 'Install HitCounter into your app.'
  task :install do
    dir = Gem.searcher.find('hit_counter').full_gem_path
    system "rsync -ruv #{dir}/public/images public/images"
  end
end