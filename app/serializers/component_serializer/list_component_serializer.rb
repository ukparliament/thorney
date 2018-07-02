module ComponentSerializer
  # Creates a list using the array of objects passed to it. Can be used with atoms and components, including cards.
  class ListComponentSerializer < ComponentSerializer::BaseComponentSerializer
    # Enum-like construct for list types
    module Type
      UNORDERED = 'ul'.freeze
      ORDERED = 'ol'.freeze
    end

    # Initialise a list component with an array of objects.
    #
    # @param [Array<Hash>] components an array of objects, each object is a component or atom.
    #
    # @example Creating an unordered pipe list component
    #   ComponentSerializer::ListComponentSerializer.new(components, display: 'pipe', list_type: ComponentSerializer::ListComponentSerializer::Type::UNORDERED)
    #
    # @param [String] display containing the type of css class for the list.
    # @param [String] list_type indicating if the list is a ordered or unordered list, with a default of unordered.
    def initialize(components, display: 'block', list_type: Type::ORDERED)
      @components = components
      @display = display
      @list_type = list_type
    end

    private

    def name
      "list__#{@display}"
    end

    def data
      {
        type:       @list_type,
        css_class:  "--#{@display}",
        components: @components
      }
    end
  end
end
