module PageSerializer
  class SearchPage
    class ResultsPageSerializer < PageSerializer::SearchPage
      private

      def meta
        {}.tap do |meta|
          meta[:title] = title
          meta[:request_id] = request_id if request_id
          meta[:components] = meta_components if total_results.positive?
          meta[:opensearch_description_url] = opensearch_description_url if opensearch_description_url
        end
      end

      def title
        t('search.title.with_query', query: @query)
      end

      def meta_components
        [{ name: 'head__search-result-tracking' }]
      end

      def content
        [].tap do |content|
          content << ComponentSerializer::SectionComponentSerializer.new(section_primary_components('search.results-heading', @query, true), type: 'primary').to_h
          content << ComponentSerializer::SectionComponentSerializer.new(results_section_components, content_flag: true).to_h
          content << ComponentSerializer::SectionComponentSerializer.new(@pagination_helper.navigation_section_components).to_h if total_results >= 1
        end
      end

      def results_section_components
        [].tap do |content|
          content << results_section_heading
          content << ComponentSerializer::StatusComponentSerializer.new(type: 'highlight', display_data: [display_data(component: 'status', variant: 'highlight')], components: [ComponentSerializer::ParagraphComponentSerializer.new([{ content: 'search.new-search' }]).to_h]).to_h
          content << ComponentSerializer::ListComponentSerializer.new(display: 'generic', display_data: [display_data(component: 'list', variant: 'block')], components: SearchResultHelper.create_search_results(@results)).to_h if total_results.positive?
        end
      end

      def results_section_heading
        translation_data = { count: total_results }

        return ComponentSerializer::HeadingComponentSerializer.new(content: ['search.no-results'], size: 2).to_h if total_results < 1

        ComponentSerializer::HeadingComponentSerializer.new(translation_key: 'search.count', translation_data: translation_data, size: 2).to_h
      end
    end
  end
end
