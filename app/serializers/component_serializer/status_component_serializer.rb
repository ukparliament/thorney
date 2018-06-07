module ComponentSerializer
  class StatusComponentSerializer < ComponentSerializer::BaseComponentSerializer
    # Initialise a status component.
    #
    # @param [String] type a string that represents the type for the status component.
    # @param [Array<Hash>] display_data a hash containing display data.
    # @param [String] selector a string to be the id attribute of the status component.
    # @param [Array<Object>] components objects that are to be children of the status component.
    def initialize(type: nil, display_data: nil, selector: nil, components: nil)
      @type = type
      @display_data = display_data
      @selector = selector
      @components = components
    end

    def name
      "status__#{@type}"
    end

    def data
      {}.tap do |hash|
        hash[:link] = @link if @link
        hash[:display] = display_hash(@display_data) if @display_data
        hash[:selector] = @selector if @selector
        hash[:components] = @components if @components
      end
    end
  end
end
