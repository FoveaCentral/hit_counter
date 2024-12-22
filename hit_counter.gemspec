# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name = 'hit_counter'
  s.version = '1.0.5'
  s.licenses = ['MIT']
  s.summary = 'Self-hosted Ruby version of that old 90s chestnut, the web-site hit counter.'
  s.description = 'Why roast this chestnut by that open fire, you ask? Cause ' \
                  'thousands and thousands of Internet vets are still using the one we ' \
                  "wrote in PHP eons ago and we don't want to be squandering any incidental " \
                  "Google juice, that's why."
  s.homepage = 'https://github.com/FoveaCentral/hit_counter'
  s.authors = ['Roderick Monje']

  s.add_dependency 'addressable'
  s.add_dependency 'mongoid'
  s.add_dependency 'rmagick'

  s.files = %w[
    Gemfile
    Rakefile
    config/initializers/mime_types.rb
    config/mongoid.yml
    lib/hit_counter.rb
    lib/tasks/install.rake
    public/images/digits/celtic/0.png
    public/images/digits/celtic/1.png
    public/images/digits/celtic/2.png
    public/images/digits/celtic/3.png
    public/images/digits/celtic/4.png
    public/images/digits/celtic/5.png
    public/images/digits/celtic/6.png
    public/images/digits/celtic/7.png
    public/images/digits/celtic/8.png
    public/images/digits/celtic/9.png
    public/images/digits/odometer/0.png
    public/images/digits/odometer/1.png
    public/images/digits/odometer/2.png
    public/images/digits/odometer/3.png
    public/images/digits/odometer/4.png
    public/images/digits/odometer/5.png
    public/images/digits/odometer/6.png
    public/images/digits/odometer/7.png
    public/images/digits/odometer/8.png
    public/images/digits/odometer/9.png
    public/images/digits/scout/0.png
    public/images/digits/scout/1.png
    public/images/digits/scout/2.png
    public/images/digits/scout/3.png
    public/images/digits/scout/4.png
    public/images/digits/scout/5.png
    public/images/digits/scout/6.png
    public/images/digits/scout/7.png
    public/images/digits/scout/8.png
    public/images/digits/scout/9.png
  ]
  s.required_ruby_version = '>= 3.1'
  s.metadata['rubygems_mfa_required'] = 'true'
end
