module ComponentSerializer
  class HintComponentSerializer < ComponentSerializer::BaseComponentSerializer
    # Initialise a hint component. In the front-end, this is a span element with the class of hint.
    #
    # @param [String] content a translation block that is evaluated in the front-end
    # @param [Array<Hash>] display_data all the css classes for the component
    def initialize(content: nil, display_data: [])
      @content = content
      @display_data = display_data
    end

    private

    def name
      'hint'
    end

    def data
      {}.tap do |hash|
        hash[:display] = display_hash(@display_data) if @display_data
        hash[:content] = @content if @content
      end
    end
  end
end
