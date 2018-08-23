module ComponentSerializer
  class HeadingComponentSerializer < ComponentSerializer::BaseComponentSerializer
    # Initialise a heading component.
    #
    # @param [Array<String>] content strings of text to be used within heading elements.
    # @param [String] translation_key a translation block.
    # @param [Hash] translation_data a hash of data that is to be used in the translation block.
    # @param [Integer] size number from 1 - 4 to be placed in the <h> tag.
    # @param [String] link the URL or other link conneted to the heading.
    #
    # @example Initialising a heading component with content
    #  string = 'House of Commons'
    #  integer = 3
    #  link = '/mps'
    #  ComponentSerializer::HeadingComponentSerializer.new(content: [string_or_translation_key], size: integer, link: link).to_h
    #
    # @example Initialising a heading component with a translation
    #  translation_key = 'shared.meta.title'
    #  count_or_other_data_key = 'count of 66'
    #  integer = 3
    #  link = '/mps'
    #  ComponentSerializer::HeadingComponentSerializer.new(translation_key: translation_key, translation_data: { count: count_or_other_data_key }, size: integer, link: link).to_h
    def initialize(content: nil, translation_key: nil, translation_data: nil, size: nil, link: nil)
      @content = content
      @translation_key = translation_key
      @translation_data = translation_data
      @size = size
      @link = link
    end

    private

    def name
      'heading'
    end

    def data
      {}.tap do |hash|
        hash[:content] = @content if @content
        hash[:translation] = translation_hash if @translation_key
        hash[:size] = @size
        hash[:link] = @link if @link
      end
    end

    def translation_hash
      {}.tap do |hash|
        hash[:key] = @translation_key
        hash[:data] = @translation_data if @translation_data
      end
    end
  end
end
