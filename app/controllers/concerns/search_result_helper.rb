module SearchResultHelper
  class << self
    # A method that uses the CardComponentSerializer to create search results
    #
    # @param [Array<Object>] results an array of result objects that is used to create search results
    def create_search_results(results)
      results.entries.map do |entry|
        ComponentSerializer::CardComponentSerializer.new(
          'card__search-result',
          search_result_data(heading_text: entry.title, url: entry.url, list_hint: list_hint_data(entry), paragraph_text: entry.content)
        ).to_h
      end
    end

    private

    def search_result_data(heading_text: nil, url: nil, list_hint: nil, paragraph_text: nil)
      {}.tap do |hash|
        hash[:heading_text] = heading_text if heading_text
        hash[:url] = url if url
        hash[:list_hint] = list_hint if list_hint
        hash[:paragraph_text] = paragraph_text if paragraph_text
      end
    end

    def list_hint_data(entry)
      {}.tap do |hash|
        handle_hint_type_and_text(hash, entry)
        hash[:url] = entry.formatted_url
      end
    end

    def list_hint_type(entry)
      types = ['hint']
      types << 'theme--grey-4' unless entry.hint_types.include?('Beta')

      types.join(' ')
    end

    def list_hint_text(entry)
      entry.hint_types.first
    end

    def no_hint?(entry)
      entry&.hint_types&.empty?
    end

    def handle_hint_type_and_text(hash, entry)
      return hash if no_hint?(entry)

      hash.tap do |h|
        h[:type] = list_hint_type(entry)
        h[:text] = list_hint_text(entry)
      end
    end
  end
end
