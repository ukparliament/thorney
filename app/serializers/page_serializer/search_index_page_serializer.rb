module PageSerializer
  class SearchIndexPageSerializer < PageSerializer::BasePageSerializer
    # Initialise a Search index page serializer.
    #
    # @param [String] query a query string used for the search.
    # @param [Array<Object>] results an array of objects used for displaying results.
    # @param [Hash] pagination_hash a hash containing data used for pagination.
    def initialize(query: nil, results: nil, pagination_hash: nil)
      @query = query
      @results = results
      @pagination_helper = PaginationHelper.new(pagination_hash) if pagination_hash
    end

    private

    def title
      translation_key = @query ? 'search.title.with_query' : 'search.title.without_query'

      t(translation_key, query: @query)
    end

    def content
      return content_without_query unless @query

      content_with_query
    end

    def content_without_query
      [
        ComponentSerializer::SectionComponentSerializer.new(section_primary_components('search.heading'), type: 'primary', content_flag: true).to_h
      ]
    end

    def content_with_query
      [].tap do |content|
        content << ComponentSerializer::SectionComponentSerializer.new(section_primary_components('search.results-heading'), type: 'primary').to_h
        content << ComponentSerializer::SectionComponentSerializer.new(results_section_components, content_flag: true).to_h
        content << ComponentSerializer::SectionComponentSerializer.new(@pagination_helper.navigation_section_components).to_h if @results.totalResults.to_i >= 1
      end
    end

    def section_primary_components(results_heading)
      [
        ComponentSerializer::HeadingComponentSerializer.new(heading: [results_heading], size: 1).to_h,
        ComponentSerializer::SearchFormComponentSerializer.new(@query).to_h
      ]
    end

    def results_section_components
      translation_data = { count: @results.totalResults }

      [
        ComponentSerializer::HeadingComponentSerializer.new(translation_key: 'search.about-count', translation_data: translation_data, size: 2).to_h,
        ComponentSerializer::StatusHighlightComponentSerializer.new([ComponentSerializer::ParagraphComponentSerializer.new(['search.status.highlight']).to_h]).to_h,
        ComponentSerializer::ListComponentSerializer.new(SearchResultHelper.create_search_results(@results)).to_h
      ]
    end
  end
end
