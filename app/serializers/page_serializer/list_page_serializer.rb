module PageSerializer
  class ListPageSerializer < PageSerializer::BasePageSerializer
    # Initialise a list page serializer.
    #
    # @param [ActionDispatch::Request] request the current request object
    # @param [String] page_title title of the page
    # @param [Array<Hash>] list_components an array of components to be passed into the list
    # @param [Array<Hash>] data_alternates array containing the href and type of the alternative data url
    def initialize(request: nil, page_title: nil, list_components: nil, data_alternates: nil)
      @page_title = page_title
      @list_components = list_components
      @data_alternates = data_alternates

      super(request: request, data_alternates: data_alternates)
    end

    private

    def meta
      super(title: @page_title)
    end

    def content
      [].tap do |content|
        content << ComponentSerializer::SectionComponentSerializer.new(components: section_primary_components, type: 'primary').to_h
        content << ComponentSerializer::SectionComponentSerializer.new(components: section_components, type: 'section').to_h
      end
    end

    def section_primary_components
      [ComponentSerializer::Heading1ComponentSerializer.new({ heading_content: @page_title }).to_h]
    end

    def section_components
      [ComponentSerializer::ListComponentSerializer.new(display: 'generic', display_data: [display_data(component: 'list', variant: 'block')], components: @list_components).to_h]
    end
  end
end
