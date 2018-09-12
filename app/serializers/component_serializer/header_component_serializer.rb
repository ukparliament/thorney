module ComponentSerializer
  class HeaderComponentSerializer < ComponentSerializer::BaseComponentSerializer
    # Initialise a header component.
    #
    # @param [Array<Object>] components items that form the children of the header component.
    #
    # @example Initialising a header component
    #  a_serializer = ComponentSerializer::StatusComponentSerializernew(type: 'banner', display_data: [display_data(component: 'status', variant: 'banner')], selector: 'css id).to_h
    #  ComponentSerializer::HeaderComponentSerializer.new([a_serializer]).to_h
    def initialize(components: nil)
      @components = components
    end

    def name
      'header'
    end

    def data
      { 'components': @components }
    end
  end
end
