class HitCounter
  include Mongoid::Document
  include Mongoid::Timestamps

  # Mongo Config ===================================================================================
  field :url
  field :hits, :type => Integer, :default => 0

  # Validates the <code>HitCounter</code>'s URL.
  #
  # If the URI library can parse the value and the scheme is valid, then we assume the url is valid.
  class UrlValidator < ActiveModel::EachValidator
    def validate_each record, attribute, value
      begin
        uri = Addressable::URI.parse value

        if !['http', 'https'].include? uri.scheme
          raise Addressable::URI::InvalidURIError
        end
      rescue Addressable::URI::InvalidURIError
        record.errors[attribute] << 'Invalid URL'
      end
    end
  end

  validates :url, :presence => true, :url => true, :uniqueness => true

  # Class methods ==================================================================================

  # Returns a <code>HitCounter</code> matching the specified URL. The HitCounter is created if no
  # matching one is found.
  #
  # * *Args*
  #   - +url+ -> the URL for the site being counted
  # * *Returns*
  #   - the site's HitCounter
  def self.get url
    self.find_or_create_by :url => HitCounter.normalize_url(url)
  end

  # Instance methods: Overrides ====================================================================

  # Sets the URL to be tracked. The http prefix is optional.
  #
  # * *Args*
  #   - +value+ -> the URL for the site being counted
  # * *Returns*
  #   - the value
  def url= value
    self[:url] = HitCounter.normalize_url value
  end

  # Instance methods ===============================================================================

  # Returns the hit count as a PNG image, using the specified style:
  #   1 odometer
  #   2 scout
  #   3 Celtic
  #
  # * *Args*
  #   - +style_number+ -> the image style
  # * *Returns*
  #   - the current hit count as a PNG image
  def image style_number = 0
    image = HitCounter.cat_image self.hits.to_s, style_number.to_i - 1
    image.format = 'png'
    image
  end

  # Increments the hit count and saves the HitCounter.
  #
  # * *Returns*
  #   - true if the save was successful
  def increment
    self.hits += 1
    self.save
  end

  private

  STYLES = ['odometer', 'scout', 'celtic']

  def self.cat_image number = '0', style_index = 0, images = Magick::ImageList.new
    return images.append(false) if number.blank?
    HitCounter.cat_image number[1..-1], style_index, images << Magick::Image.read("#{Rails.root}/public/images/digits/#{STYLES[style_index]}/#{number[0..0]}.gif").first
  end

  def self.normalize_url value
    value !~ %r{^http://} ? "http://#{value}" : value
  end
end