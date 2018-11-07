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
    # @param [String] display the style of the list.
    # @param [Array<Hash>] display_data all the css classes for the list.
    # @param [String] type indicating if the list is an ordered or unordered list, with a default of ordered.
    # @param [Array<String, Hash>] contents an array of translation blocks, either strings or hashes with a link, each is evaluated in the front-end.
    # @param [Array<Hash>] components an array of objects, each object is a component or atom.
    #
    # @example Creating a list component with content
    #  type_of_list = 'generic'
    #  display_data = [display_data(component: 'list', variant: 'block')]
    #  ol_or_ul_list = ol
    #  string_or_translation_key = 'An item in a list'
    #  ComponentSerializer::ListComponentSerializer.new(display: type_of_list, display_data: display_data, type: ol_or_ul_list, contents: [string_or_translation_key, string_or_translation_key]).to_h
    #
    # @example Initialising a link component with components
    #  type_of_list = 'generic'
    #  display_data = [display_data(component: 'list', variant: 'block')]
    #  ol_or_ul_list = ol
    #  a_serializer = ComponentSerializer::CardComponentSerializer.new(name: 'card__generic', data: { card_type: 'small', heading: 'Card Heading', paragraph: 'Card information' }).to_h
    #  ComponentSerializer::ListComponentSerializer.new(display: type_of_list, display_data: display_data, type: ol_or_ul_list, components: [a_serializer, a_serializer]).to_h
    def initialize(display: nil, display_data: nil, type: Type::ORDERED, contents: nil, components: nil)
      @display = display
      @display_data = display_data
      @type = type
      @contents = contents
      @components = components
    end

    private

    def name
      "list__#{@display}"
    end

    def data
      {}.tap do |hash|
        hash[:type] = @type
        hash[:display] = display_hash(@display_data) if @display_data
        hash[:contents] = contents if @contents
        hash[:components] = @components if @components
      end
    end

    def contents
      @contents.map do |content|
        element = { content: content } unless content.is_a?(Hash)
        element = content if content.is_a?(Hash)
        element
      end
    end
  end
end
