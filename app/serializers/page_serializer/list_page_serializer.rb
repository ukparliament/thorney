module PageSerializer
  class ListPageSerializer < PageSerializer::BasePageSerializer
    # Initialise a list page serializer.
    #
    # @param [ActionDispatch::Request] request the current request object
    # @param [ComponentSerializer::Heading1ComponentSerializer] heading_component a heading object used for heading information
    # @param [Array<Hash>] list_components an array of components to be passed into the list
    # @param [Array<Hash>] data_alternates array containing the href and type of the alternative data url
    def initialize(request: nil, heading_component: nil, status_component: nil, list_components: nil, data_alternates: nil)
      @heading_component = heading_component
      @status_component = status_component
      @list_components = list_components
      @data_alternates = data_alternates

      super(request: request, data_alternates: data_alternates)
    end

    private

    def meta
      super(title: @heading_component.to_s)
    end

    def content
      [].tap do |content|
        content << ComponentSerializer::SectionComponentSerializer.new(components: section_primary_components, type: 'primary', content_flag: true).to_h
        content << ComponentSerializer::SectionComponentSerializer.new(components: section_components, type: 'section').to_h
      end
    end

    def section_primary_components
      [].tap do |content|
        content << @heading_component.to_h
        content << @status_component.to_h if @status_component
      end
    end

    def section_components
      list_items = @list_components
      list_items = [CardFactory.new(heading_text: 'shared.no-results').build_card] if @list_components.empty?

      [ComponentSerializer::ListComponentSerializer.new(display: 'generic', display_data: [display_data(component: 'list', variant: 'block')], components: list_items).to_h]
    end
  end
end
