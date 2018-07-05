module ComponentSerializer
  class HeaderComponentSerializer < ComponentSerializer::BaseComponentSerializer
    # Initialise a header component.
    #
    # @param [Array<Object>] components items that form the children of the header component.
    def initialize(components)
      @components = components
    end

    def name
      'header'
    end

    def data
      @components
    end
  end
end
