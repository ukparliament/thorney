module SearchResultHelper
  class << self
    # A method that uses the CardComponentSerializer to create search results
    #
    # @param [Array<Object>] results an array of result objects that is used to create search results
    def create_search_results(results)
      results.entries.map do |entry|
        ComponentSerializer::CardComponentSerializer.new(
          name: 'card__search__search-result',
          data: search_result_data(entry: entry, heading_text: entry.title, url: entry.url, hint: hint_data(entry), short_url: entry.formatted_url, paragraph_content: entry.content)
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
      entry&.hint_types&.map do |hint_type|
        ComponentSerializer::HintComponentSerializer.new(display_data: [hint_display_data(hint_type)]).to_h
      end
    end

    def hint_display_data(hint_type)
      {}.tap do |hash|
        hash[:component] = 'theme'
        hash[:variant] = 'grey-4' unless hint_type == 'Beta'
        hash[:content] = hint_type
      end
    end

    def no_hint?(entry)
      entry&.hint_types&.empty?
    end
  end
end
