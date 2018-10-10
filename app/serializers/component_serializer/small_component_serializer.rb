module ComponentSerializer
  class SmallComponentSerializer < BaseComponentSerializer
    # Initialise a small partial.
    #
    # @param [Hash] content a piece content to be wrapped in <small> tags. The hash has a content key and and optional link key.
    #
    # @example Initialising a small partial
    #  content = { content: 'Foo', link: '/bar' }
    #  ComponentSerializer::SmallComponentSerializer.new(content).to_h
    def initialize(content)
      @content = content
    end

    def name
      'partials__small'
    end

    def data
      @content
    end
  end
end
