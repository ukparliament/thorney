module ComponentSerializer
  class LinkComponentSerializer < ComponentSerializer::BaseComponentSerializer
    # Initialise a link component.
    #
    # @param [String] link a string to be placed in an href.
    # @param [Array<Hash>] display_data a hash containing display data.
    # @param [String] label a string to be used as the label attribute for the html element.
    # @param [String] selector a string to be the id attribute of the link.
    # @param [String] content a translation block that is evaluated into a string in the front-end.
    # @param [Array<Object>] components items that form the children of the link component.
    def initialize(link: nil, display_data: nil, label: nil, selector: nil, content: nil, components: nil)
      @link = link
      @display_data = display_data
      @label = label
      @selector = selector
      @content = content
      @components = components
    end

    def name
      'link'
    end

    def data
      {}.tap do |hash|
        hash[:link] = @link if @link
        hash[:display] = display_hash(@display_data) if @display_data
        hash[:label] = @label if @label
        hash[:selector] = @selector if @selector
        hash[:content] = @content if @content
        hash[:components] = @components if @components
      end
    end
  end
end
