module OpenGraphHelper
  # Creates a hash populated with the Open Graph image standard properties
  #
  # @return [Hash]
  def self.open_graph_image_standards
    {}.tap do |hash|
      hash[:width]        = '400'
      hash[:height]       = '400'
      hash[:twitter_card] = 'summary'
      hash[:url]          = 'https://static.parliament.uk/assets-public/opengraph-oblong.png'
    end
  end

  # Returns a hash depending on whether an image_id is nil or not
  #
  # @param [String] image_id the ID of the image
  #
  # @return [Hash]
  def self.image_parameters(image_id)
    if image_id
      { url: "#{ENV['IMAGE_SERVICE_URL']}/#{image_id}.jpeg?crop=CU_1:1&width=400&quality=100" }
    else
      { width: '1200', height: '630', twitter_card: 'summary_large_image' }
    end
  end

  # Creates the Open Graph information hash
  #
  # @param [String] page_title title of the page
  # @param [String] request_original_url the original url requested
  # @param [String] image_id the ID of the image on a page
  #
  # @return [Hash]
  def self.information(page_title:, request_original_url:, image_id: nil)
    image_hash = open_graph_image_standards.merge(image_parameters(image_id))

    {}.tap do |info_hash|
      info_hash[:title]        = page_title
      info_hash[:original_url] = request_original_url
      info_hash[:image_url]    = image_hash[:url].html_safe
      info_hash[:image_width]  = image_hash[:width]
      info_hash[:image_height] = image_hash[:height]
      info_hash[:twitter_card] = image_hash[:twitter_card]
    end
  end
end
