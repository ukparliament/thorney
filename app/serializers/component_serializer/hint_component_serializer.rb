module ComponentSerializer
  class HintComponentSerializer < ComponentSerializer::BaseComponentSerializer
    # Initialise a hint component. In the front-end, this is a span element with the class of hint.
    #
    # @param [String] content a translation block that is evaluated in the front-end
    # @param [Array<Hash>] display_data all the css classes for the component
    #
    # @example Initialising a hint partial
    #  text_displayed_on_hint = 'PDF'
    #  display_data = [display_data(component: 'hint')]
    #  ComponentSerializer::HintComponentSerializer.new(content: text_displayed_on_hint, display_data: display_data).to_h
    def initialize(content: nil, display_data: nil)
      @content = content
      @display_data = display_data
    end

    private

    def name
      'partials__hint'
    end

    def data
      {}.tap do |hash|
        hash[:display] = display_hash(@display_data) if @display_data
        hash[:content] = @content if @content
      end
    end
  end
end
