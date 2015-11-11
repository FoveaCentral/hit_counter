# Copyright (c) 2011 Roderick Monje
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
require 'rubygems'
require 'bundler/setup'
Bundler.require :default

# Ruby version of that old 90s chestnut, <BLINK>the web-site hit counter</BLINK>
#
# @example
#   hc = HitCounter.get 'cnn.com'
#   hc.increment
class HitCounter
  include Mongoid::Document
  include Mongoid::Timestamps

  # Mongo Config ===============================================================
  field :url
  field :hits, type: Integer, default: 0

  # Validates the <code>HitCounter</code>'s URL.
  #
  # If the URI library can parse the value and the scheme is valid, then we
  # assume the url is valid.
  class UrlValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      uri = Addressable::URI.parse value
      fail Addressable::URI::InvalidURIError unless %w(http https).include?(
        uri.scheme
      )
    rescue Addressable::URI::InvalidURIError
      record.errors[attribute] << 'Invalid URL'
    end
  end

  validates :url, presence: true, url: true, uniqueness: true

  # Class methods ==============================================================

  # Returns a <code>HitCounter</code> matching the specified URL. The HitCounter
  # is created if no matching one is found. In the latter case, the hits
  # argument specifies the starting count.
  #
  # @param url [String] the URL for the site being counted
  # @param hits [Integer] the number of hits to start with
  # @return [HitCounter] the site's HitCounter
  # @example
  #   hc = HitCounter.get 'cnn.com'
  #   hc = HitCounter.get 'cnn.com', 100
  def self.get(url, hits = 0)
    args = { url: normalize_url(url) }
    args[:hits] = hits unless where(conditions: args).exists?
    find_or_create_by args
  end

  # Instance methods: Overrides ================================================

  # Sets the number of hits.
  #
  # @param value [Integer] the initial number of hits
  # @return [Integer] the number of hits
  # @example
  #   hc.hits = 100
  def hits=(value)
    self[:hits] = value.to_i
  end

  # Sets the URL to be tracked. The http prefix is optional.
  #
  # @param value [String] the URL for the site being counted
  # @return [String] the normalized URL
  # @example
  #   hc.url = 'cnn.com'
  def url=(value)
    self[:url] = HitCounter.normalize_url value
  end

  # Instance methods ===========================================================

  # Returns the hit count as a PNG image, using the specified style:
  #   1 odometer
  #   2 scout
  #   3 Celtic
  #
  # @param style_number [String] the image style
  # @return [Magick::Image] the current hit count as a PNG image
  # @example
  #   hc.image = 1
  def image(style_number)
    image = HitCounter.cat_image hits.to_s,
                                 HitCounter.normalize_style_number(style_number)
    image.format = 'png'
    image
  end

  # Increments the hit count and saves the HitCounter.
  #
  # @return [true] if the save was successful
  # @example
  #   hc.increment
  def increment
    self.hits += 1
    save
  end

  STYLES = %w(odometer scout celtic)

  def self.cat_image(number, style_index, images = Magick::ImageList.new)
    return images.append(false) if number.blank?
    cat_image number[1..-1], style_index, images << Magick::Image
      .read(
        "#{Rails.root}/public/images/digits/#{STYLES[style_index]}/"\
        "#{number[0..0]}.png"
      ).first
  end

  def self.normalize_style_number(value)
    value = value.to_i
    value -= 1 if value > 0

    if value >= 0 && value < STYLES.size
      return value
    else
      value % 3
    end
  end

  def self.normalize_url(value)
    value !~ %r{^http://} ? "http://#{value}" : value
  end
end

if defined? Rails
  # Overriding Rails to include install task
  class Railtie < Rails::Railtie
    rake_tasks do
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
    end
  end
end
