module SearchResultHelper
  class << self
    # A method that uses the CardComponentSerializer to create search results
    #
    # @param [Array<Object>] results an array of result objects that is used to create search results
    def create_search_results(results)
      results.entries.map do |entry|
        ComponentSerializer::CardComponentSerializer.new(
          'card__search__search-result',
          search_result_data(entry: entry, heading_text: entry.title, url: entry.url, hint: hint_data(entry), short_url: entry.formatted_url, paragraph_content: entry.content)
        ).to_h
      end
    end

    private

    def search_result_data(entry: nil, heading_text: nil, url: nil, hint: nil, short_url: nil, paragraph_content: nil)
      {}.tap do |hash|
        hash[:heading_text] = heading_text if heading_text
        hash[:url] = url if url
        hash[:hints] = hint unless no_hint?(entry) || !hint
        hash[:short_url] = short_url if short_url
        hash[:paragraph_content] = paragraph_content if paragraph_content
      end
    end

    def hint_data(entry)
      { name: 'hint', data: hint_display_data(entry) }
    end

    def hint_display_data(entry)
      {}.tap do |hash|
        hash[:component] = 'hint'
        hash[:variant] = 'theme'
        hash[:modifier] = 'grey-4' unless entry.hint_types.include?('Beta')
        hash[:content] = entry.hint_types.first
      end
    end

    def no_hint?(entry)
      entry&.hint_types&.empty?
    end
  end
end
