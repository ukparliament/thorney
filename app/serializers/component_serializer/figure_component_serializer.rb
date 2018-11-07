module ComponentSerializer
  class FigureComponentSerializer < BaseComponentSerializer
    # Initialise a figure partial.
    #
    # @param [Array<Hash>] display_data used for the element's css.
    # @param [String] link a URL or other link which the user will follow if they click on the figure.
    # @param [boolean] aria_hidden an optional parameter which adds a aria_hidden property to data.
    # @param [boolean] tab_index an optional parameter which adds a tab_index property to data.
    # @param [Array<Hash>] source_info is a hash containing the any source tag information, up to three key/value pairs. Including: media, srcset and additional srcset.
    # @param [Array<Hash>] img is a hash containing three key/value pairs to go in the img tag. One string of text or translation key for the alt label, one with any data from the backend to go in the alt label and the link for the src.
    # @param [String/Array<Hash>] figcap  can be a string or translation key, or it can be a hash containing a translation key and data to be interpolated. To create the hash you must use the ContentDataHelper
    #
    # @example Initialising a figure partial
    #  display_data_info = [display_data(component: 'avitar', variant: 'round')]
    #  link_when_image_clicked = 'https://beta.parliament.uk/media/S3bGSTqn'
    #  boolean = true
    #  size_of_image = '(min-width: 480px)'
    #  links_to_source_info = 'https://api.parliament.uk/photo/S3bGSTqn.jpeg?width=732&amp;quality=90, https://api.parliament.uk/photo/S3bGSTqn.jpeg?width=1464&amp;quality=90 2x'
    #  text_describing_image = 'This is a picture of Dianne Abbott'
    #  backend_data_for_text_describing_image = 'MP for Hackeny'
    #  img_source_link = 'https://api.parliament.uk/photo/S3bGSTqn.jpeg?width=1464&amp;quality=90'
    #  figcap_content = 'Here is a picture of an MP' or ContentDataHelper.content_data(content: 'translation_key' , link: 'parliament.uk' )
    #  ComponentSerializer::FigureComponentSerializer.new(display_data: display_data_info, link: link_when_image_clicked, aria_hidden: boolean, tab_index: boolean, source_info: { source_media: size_of_image, source_srcset: links_to_source_info, source_srcset_2: links_to_source_info }, img: { alt_text: text_describing_image, alt_data: backend_data_for_text_describing_image, source: img_source_link }, figcap: figcap_content).to_h
    def initialize(display_data: nil, link: nil, aria_hidden: nil, tab_index: nil, source_info: nil, img: nil, figcap: nil)
      @display_data = display_data
      @link = link
      @aria_hidden = aria_hidden
      @tab_index = tab_index
      @source_info = source_info
      @img = img
      @figcap = figcap
    end

    def name
      'partials__figure'
    end

    def data
      [*base_hash, *extract_source_info, *extract_img, *extract_figcap].to_h
    end

    def base_hash
      {}.tap do |hash|
        hash[:display] = display_hash(@display_data) if @display_data
        hash[:link] = @link if @link
        hash[:aria_hidden] = @aria_hidden if @aria_hidden
        hash[:tab_index] = @tab_index if @tab_index
      end
    end

    def extract_source_info
      {}.tap do |hash|
        hash[:source_media] = @source_info[:source_media] if @source_info && @source_info[:source_media]
        hash[:source_srcset] = @source_info[:source_srcset] if @source_info && @source_info[:source_srcset]
        hash[:source_srcset_2] = @source_info[:source_srcset_2] if @source_info && @source_info[:source_srcset_2]
      end
    end

    def extract_img
      {}.tap do |hash|
        hash[:alt_text] = @img[:alt_text] if @img[:alt_text]
        hash[:alt_data] = @img[:alt_data] if @img[:alt_data]
        hash[:source] = @img[:source] if @img[:source]
      end
    end

    def extract_figcap
      {}.tap do |hash|
        hash[:figcaption] = { content: @figcap } if @figcap.is_a?(String)
        hash[:figcaption] = @figcap if @figcap.is_a?(Hash)
      end
    end
  end
end
