namespace :hit_counter do
  desc 'Install HitCounter into your app.'
  task :install do
    puts 'Installing required image files...'
    system "rsync -ruv #{Gem.searcher.find('hit_counter').full_gem_path}"\
      '/config .'
    system "rsync -ruv #{Gem.searcher.find('hit_counter').full_gem_path}"\
      '/public .'
  end
end
