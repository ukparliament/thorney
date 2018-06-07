module ComponentSerializer
  class SearchFormComponentSerializer < ComponentSerializer::BaseComponentSerializer
    # Initialise a search form component.
    #
    # @param [String] query string to passed in as the value attribute of the input element.
    # @param [Array<Object>] components components that are intended to be part of the search form.
    def initialize(query, components)
      @query = query
      @components = components
    end

    private

    def name
      'form__search'
    end

    def data
      {}.tap do |hash|
        hash[:value] = @query if @query
        hash[:key_word] = 'search.key-word'
        hash[:components] = @components
      end
    end
  end
end
