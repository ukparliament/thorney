module ComponentSerializer
  class SearchFormComponentSerializer < ComponentSerializer::BaseComponentSerializer
    # Initialise a search form component.
    #
    # @param [String] query string to passed in as the value attribute of the input element.
    def initialize(query = nil)
      @query = query
    end

    private

    def name
      'form__search'
    end

    def data
      return { value: @query } if @query
      'form__search'
    end
  end
end
