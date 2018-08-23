module PageSerializer
  class SearchPage
    class LandingPageSerializer < PageSerializer::SearchPage
      # This serializer inherits the basic search components from the search page, but adds in the landing page specific ones.
      private

      def meta
        super(title: title).tap do |meta|
          meta[:opensearch_description_url] = opensearch_description_url if opensearch_description_url
        end
      end

      def title
        translation_key = @flash_message ? 'search.title.with_flash_message' : 'search.title.without_query'

        t(translation_key)
      end

      def content
        return content_with_flash_message if @flash_message

        content_without_query
      end

      def content_with_flash_message
        [].tap do |content|
          content << ComponentSerializer::SectionComponentSerializer.new(section_primary_components('search.search-heading', @query, true), type: 'primary').to_h
          content << ComponentSerializer::SectionComponentSerializer.new([ComponentSerializer::StatusComponentSerializer.new(type: 'highlight', display_data: flash_message_display_data, components: [flash_message_paragraph]).to_h], content_flag: true).to_h
        end
      end

      def flash_message_paragraph
        ComponentSerializer::ParagraphComponentSerializer.new([{ content: @flash_message }]).to_h
      end

      def flash_message_display_data
        [display_data(component: 'status', variant: 'highlight'), display_data(component: 'theme', variant: 'caution')]
      end

      def content_without_query
        [ComponentSerializer::SectionComponentSerializer.new(section_primary_components('search.search-heading'), type: 'primary', content_flag: true).to_h]
      end
    end
  end
end
