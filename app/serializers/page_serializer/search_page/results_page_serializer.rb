module PageSerializer
  class SearchPage
    class ResultsPageSerializer < PageSerializer::SearchPage
      # This serilaizer inherits some of its components from the search page serializer, but also adds in the results from the search.

      private

      def meta
        super(title: title).tap do |meta|
          meta[:opensearch_description_url] = opensearch_description_url if opensearch_description_url
          meta[:disable_format_detection] = true
        end
      end

      def title
        t('search.title.with_query', query: @query)
      end

      def content
        [].tap do |content|
          content << ComponentSerializer::SectionComponentSerializer.new(components: section_primary_components('search.results-heading', @query, true), type: 'primary').to_h
          content << ComponentSerializer::SectionComponentSerializer.new(components: results_section_components, content_flag: true).to_h
          content << @pagination_helper.navigation_section_components if total_results >= 1
        end
      end

      def results_section_components
        [].tap do |content|
          content << results_section_heading
          content << ComponentSerializer::ListComponentSerializer.new(display: 'generic', display_data: [display_data(component: 'list', variant: 'block')], components: SearchResultHelper.create_search_results(@results)).to_h if total_results.positive?
        end
      end

      def results_section_heading
        return ComponentSerializer::HeadingComponentSerializer.new(content: 'search.no-results', size: 2).to_h if total_results < 1

        ComponentSerializer::HeadingComponentSerializer.new(content: ContentDataHelper.content_data(content: 'search.count', count: total_results), size: 2).to_h
      end

      def foot_components
        return nil unless total_results.positive?

        {}.tap do |hash|
          hash[:components] = [{ name: 'foot__search-result-tracking' }]
        end
      end
    end
  end
end
