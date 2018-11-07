module ComponentSerializer
  class SmallComponentSerializer < BaseComponentSerializer
    # Initialise a small partial.
    #
    # @param [Hash] content a piece content to be wrapped in <small> tags. The hash has a content key and and optional link key.
    #
    # @example Initialising a small partial with content only
    #  content = 'Foo'
    #  ComponentSerializer::SmallComponentSerializer.new(content: content).to_h
    # @example Initialising a small partial with content and data
    #  When initalising with both content and data to be interpolated you must use the ContentDataHelper.
    #  content = ContentDataHelper.content_data(content: 'Foo' , bar: '/bar' )
    #  ComponentSerializer::SmallComponentSerializer.new(content: content).to_h
    def initialize(content: nil)
      @content = content
    end

    def name
      'partials__small'
    end

    def data
      element = { content: @content } unless @content.is_a?(Hash)
      element = @content if @content.is_a?(Hash)
      element
    end
  end
end
