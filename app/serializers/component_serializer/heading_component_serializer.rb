module ComponentSerializer
  class HeadingComponentSerializer < ComponentSerializer::BaseComponentSerializer
    # Initialise a heading component.
    #
    # @param [Array<String>] content strings of text to be used within heading elements.
    # @param [String] translation_key a translation block.
    # @param [Hash] translation_data a hash of data that is to be used in the translation block.
    # @param [Integer] size number from 1 - 4 to be placed in the <h> tag.
    # @param [String] link the URL or other link connected to the heading.
    #
    #  When adding a translation key with data please always use the ContentDataHelper.
    # @example Initialising a heading component with content
    #  string_or_translation_key_or_ContentDataHelper= 'House of Commons' or ContentDataHelper.content_data(content: 'Dianne Abbott', link: 'www.dianneabbott.com')
    #  integer = 3
    #  link = '/mps'
    #  ComponentSerializer::HeadingComponentSerializer.new(content: string_or_translation_key_or_ContentDataHelper, size: integer, link: link).to_h
    def initialize(content: nil, size: nil, link: nil)
      @content = content.is_a?(Hash) ? content : { content: content }
      @size = size
      @link = link
    end

    private

    def name
      'heading'
    end

    def data
      @content[:content] = @link ? link_to(@content[:content], @link) : @content[:content]
      @content[:size] = @size
      @content
    end
  end
end
