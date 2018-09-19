module PageSerializer
  class ListPageSerializer < PageSerializer::BasePageSerializer
    # Initialise a list page serializer.
    #
    # @param [String] page_title title of the page
    # @param [String] request_id AppInsights request id
    # @param [Array<Hash>] data_alternates array containing the href and type of the alternative data urls
    # @param [String] request_original_url original url of the request
    def initialize(page_title: nil, request_id: nil, data_alternates: nil, request_original_url: nil)
      @page_title = page_title
      @data_alternates = data_alternates

      super(request_id: request_id, data_alternates: data_alternates, request_original_url: request_original_url)
    end

    private

    attr_reader :page_title

    def meta
      super(title: page_title)
    end

    def content
      [].tap do |content|
        content << ComponentSerializer::SectionComponentSerializer.new(components: section_primary_components, type: 'primary').to_h
        content << ComponentSerializer::SectionComponentSerializer.new(components: section_components, type: 'section').to_h
      end
    end

    def section_primary_components
      [ComponentSerializer::Heading1ComponentSerializer.new({ heading_content: page_title }).to_h]
    end

    def section_components
      [ComponentSerializer::ListComponentSerializer.new(display: 'generic', display_data: [display_data(component: 'list', variant: 'block')], components: list_components).to_h]
    end

    def list_components
      raise StandardError, 'You must implement #list_components'
    end
  end
end
