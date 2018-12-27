module PageSerializer
  class SearchPage < PageSerializer::BasePageSerializer
    # Initialise a Search index page serializer.
    #
    # @param [ActionDispatch::Request] request the current request object.
    # @param [String] opensearch_description_url a description url for the search.
    # @param [String] query a query string used for the search.
    # @param [Array<Object>] results an array of objects used for displaying results.
    # @param [Hash] pagination_hash a hash containing data used for pagination.
    # @param [String] flash_message a translation block that is evaluated into a flash message.
    def initialize(request: nil, opensearch_description_url: nil, query: nil, results: nil, pagination_hash: nil, flash_message: nil)
      @opensearch_description_url = opensearch_description_url
      @query = query
      @results = results
      @pagination_helper = PaginationHelper.new(pagination_hash) if pagination_hash
      @flash_message = flash_message

      super(request: request, data_alternates: nil)
    end

    private

    attr_reader :opensearch_description_url

    def content
      raise StandardError, 'You must implement #content'
    end

    def section_primary_components(heading_content, context_content = nil, context_hidden = nil)
      [].tap do |content|
        content << ComponentSerializer::Heading1ComponentSerializer.new(heading: heading_content, context: context_content, context_hidden: context_hidden).to_h
        content << ComponentSerializer::SearchFormComponentSerializer.new(query: @query, components: [ComponentSerializer::SearchIconComponentSerializer.new.to_h], hide_label: true).to_h
      end
    end

    def total_results
      @results&.totalResults.to_i
    end

    # Overrides the default of true (found in the base page serializer) for including global search in the header.
    def include_global_search
      false
    end
  end
end
