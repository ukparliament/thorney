module ComponentSerializer
  class HeadingComponentSerializer < ComponentSerializer::BaseComponentSerializer
    # Initialise a heading component.
    #
    # @param [Array<String>] content strings of text to be used within heading elements.
    # @param [String] translation_key a translation block.
    # @param [Hash] translation_data a hash of data that is to be used in the translation block.
    # @param [Integer] size number from 1 - 4 to be placed in the <h> tag.
    def initialize(content: nil, translation_key: nil, translation_data: nil, size: nil)
      @content = content
      @translation_key = translation_key
      @translation_data = translation_data
      @size = size
    end

    private

    def name
      'heading'
    end

    def data
      {}.tap do |hash|
        hash[:content] = @content if @content
        hash[:translation] = translation_hash if @translation_key && @translation_data
        hash[:size] = @size
      end
    end

    def translation_hash
      { key: @translation_key, data: @translation_data }
    end
  end
end
