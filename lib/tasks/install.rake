# frozen_string_literal: true

namespace :hit_counter do
  desc 'Install HitCounter into your app.'
  task(:install) { HitCounter.install }
end
