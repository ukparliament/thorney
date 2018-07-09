module PageSerializer
  class SearchPage < PageSerializer::BasePageSerializer
    # Initialise a Search index page serializer.
    #
    # @param [String] opensearch_description_url the search description in the head section of the page.
    # @param [String] query a query string used for the search.
    # @param [Array<Object>] results an array of objects used for displaying results.
    # @param [Hash] pagination_hash a hash containing data used for pagination.
    # @param [string] flash_message a translation block that is evaluated into a flash message.
    def initialize(opensearch_description_url: nil, query: nil, results: nil, pagination_hash: nil, flash_message: nil)
      @opensearch_description_url = opensearch_description_url
      @query = query
      @results = results
      @pagination_helper = PaginationHelper.new(pagination_hash) if pagination_hash
      @flash_message = flash_message
    end

    private

    attr_reader :opensearch_description_url

    def title
      raise StandardError, 'You must implement #title'
    end

    def content
      raise StandardError, 'You must implement #content'
    end

    def section_primary_components(results_heading)
      [].tap do |content|
        content << ComponentSerializer::HeadingComponentSerializer.new(content: [results_heading], size: 1).to_h
        content << ComponentSerializer::SearchFormComponentSerializer.new(@query, [ComponentSerializer::SearchIconComponentSerializer.new.to_h]).to_h
      end
    end

    def total_results
      @results.totalResults.to_i
    end
  end
end
