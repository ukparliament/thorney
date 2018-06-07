module ComponentSerializer
  # Creates a hash where the data content is an array of strings which Dust will render into lines of text.
  class ParagraphComponentSerializer < ComponentSerializer::BaseComponentSerializer
    # Initialise a paragraph component with one or more pieces of content.
    #
    # @example
    #   strings = ['Line one content', 'Line two content']
    #   ComponentSerializer::ParagraphComponentSerializer.new(strings)
    #
    # @param [Array<String>] strings an array of one or more pieces of content to be wrapped in <p> tags.
    def initialize(strings)
      @strings = strings
    end

    private

    def name
      'paragraph'
    end

    def data
      @strings
    end
  end
end
