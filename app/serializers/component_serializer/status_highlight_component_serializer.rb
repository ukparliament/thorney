module ComponentSerializer
  class StatusHighlightComponentSerializer < BaseComponentSerializer
    # Initialise a status highlight with an array of components.
    #
    # @param [Array<Object>] components objects that are to be part of the status highlight component.
    def initialize(components)
      @components = components
    end

    private

    def name
      'status__highlight'
    end

    def data
      {
        components: @components
      }
    end
  end
end
