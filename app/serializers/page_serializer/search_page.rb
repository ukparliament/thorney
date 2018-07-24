module PageSerializer
  class SearchPage < PageSerializer::BasePageSerializer
    # Initialise a Search index page serializer.
    #
    # @param [String] query a query string used for the search.
    # @param [Array<Object>] results an array of objects used for displaying results.
    # @param [Hash] pagination_hash a hash containing data used for pagination.
    # @param [string] flash_message a translation block that is evaluated into a flash message.
    # @param [string] AppInsights request id
    def initialize(opensearch_description_url: nil, query: nil, results: nil, pagination_hash: nil, flash_message: nil, request_id: nil)
      @query = query
      @results = results
      @pagination_helper = PaginationHelper.new(pagination_hash) if pagination_hash
      @flash_message = flash_message
      @request_id = request_id if request_id
    end

    private

    attr_reader :request_id

    def meta
      raise StandardError, 'You must implement #meta'
    end

    def content
      raise StandardError, 'You must implement #content'
    end

    def section_primary_components(heading_content, context_content = nil, context_hidden = nil)
      [].tap do |content|
        content << ComponentSerializer::Heading1ComponentSerializer.new(heading_content: heading_content, context_content: context_content, context_hidden: context_hidden).to_h
        content << ComponentSerializer::SearchFormComponentSerializer.new(@query, [ComponentSerializer::SearchIconComponentSerializer.new.to_h]).to_h
      end
    end

    def total_results
      @results&.totalResults.to_i
    end
  end
end
