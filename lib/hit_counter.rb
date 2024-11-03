# Copyright the HitCounter contributors.
# SPDX-License-Identifier: MIT
# frozen_string_literal: true

require 'rmagick'
require 'rubygems'
require 'bundler/setup'
Bundler.require :default

# Self-hosted Ruby version of that old 90s chestnut, <BLINK>the web-site hit counter</BLINK>
#
# @example
#   hc = HitCounter.get 'cnn.com'
#   hc.increment
class HitCounter
  include Mongoid::Document
  include Mongoid::Timestamps

  # Mongo Config ===============================================================
  field :hits, type: Integer, default: 0
  field :url

  # Validates the <code>HitCounter</code>'s URL.
  #
  # If the URI library can parse the value and the scheme is valid, then we
  # assume the url is valid.
  class UrlValidator < ActiveModel::EachValidator
    private

    def validate_each(record, attribute, value)
      uri = Addressable::URI.parse value
      raise Addressable::URI::InvalidURIError unless %w[http https].include?(
        uri.scheme
      )
    rescue Addressable::URI::InvalidURIError
      record.errors.add attribute, 'Invalid URL'
    end
  end

  validates :hits, numericality: { only_integer: true }
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

  # Installs the required Mongoid configuration and image files.
  #
  # @return true
  # @example
  #   HitCounter.install
  def self.install
    puts 'Configuring Mongoid and installing image files...'
    full_gem_path = Gem::Specification.find_by_name('hit_counter').full_gem_path
    system "rsync -ruv #{full_gem_path}/config ."
    system "rsync -ruv #{full_gem_path}/public ."
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
    self[:url] = HitCounter.send(:normalize_url, value)
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
    image = HitCounter.send(:cat_image, hits.to_s, HitCounter.send(:normalize_style_number, style_number))
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

  # Defines the available image styles as an array. Add yours to the end.
  STYLES = %w[odometer scout celtic].freeze

  private_class_method def self.cat_image(number, style_index, images = Magick::ImageList.new)
    return images.append(false) if number.blank?

    cat_image(number[1..], style_index, images <<
      Magick::Image.read("#{Rails.root}/public/images/digits/" \
                         "#{STYLES[style_index]}/#{number[0..0]}.png").first)
  end

  private_class_method def self.normalize_style_number(value)
    value = value.to_i
    value -= 1 if value.positive?

    return value if value >= 0 && value < STYLES.size

    value % 3
  end

  private_class_method def self.normalize_url(value)
    %r{^http://}.match?(value) ? value : "http://#{value}"
  end
end
