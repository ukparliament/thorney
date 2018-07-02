module ComponentSerializer
  class HeadingComponentSerializer < ComponentSerializer::BaseComponentSerializer
    # Initialise a heading component.
    #
    # @param [Array<String>] heading strings of text to be wrapped in <h> tags.
    # @param [String] translation_key a translation block.
    # @param [Hash] translation_data a hash of data that is to be used in the translation block.
    # @param [Integer] size number from 1 - 4 to be placed in the <h> tag.
    def initialize(heading: nil, translation_key: nil, translation_data: nil, size: nil)
      @heading = heading
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
        hash[:heading] = @heading if @heading
        hash[:translation] = translation_hash if @translation_key && @translation_data
        hash[:size] = @size
      end
    end

    def translation_hash
      { key: @translation_key, data: @translation_data }
    end
  end
end
