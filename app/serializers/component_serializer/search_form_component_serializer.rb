module ComponentSerializer
  class SearchFormComponentSerializer < ComponentSerializer::BaseComponentSerializer
    # Initialise a search form component.
    #
    # @param [String] query string to passed in as the value attribute of the input element.
    # @param [Array<Object>] components components that are intended to be part of the search form.
    # @param [Boolean] global a boolean to determine if the global tags are added in the dust file.
    # @param [Boolean] hide_label a boolean to determine if the hide-label tags are added in the dust file.
    # @param [String] search_action a path which is used as the action parameter on the search form.
    #
    # @example Initialising a search form component
    #  query_nil_unless_rendering_results_page = nil
    #  an_icon_componet = ComponentSerializer::SearchIconComponentSerializer.new().to_h
    #  nil_unless_search_used_in_header = nil
    #  ComponentSerializer::SearchFormComponentSerializer.new(query: query_nil_unless_rendering_results_page, components: [an_icon_componet], global: nil_unless_search_used_in_header).to_h
    def initialize(query: nil, components: nil, global: nil, hide_label: nil, search_action: nil)
      @query = query
      @components = components
      @global = global
      @hide_label = hide_label
      @search_action = search_action
    end

    private

    def name
      'form__search'
    end

    def data
      {}.tap do |hash|
        hash[:value] = @query if @query
        hash[:global] = @global if @global
        hash['hide-label'] = @hide_label if @hide_label
        hash[:label] = 'search.label'
        hash[:components] = @components
        hash['search-action'] = @search_action if @search_action
      end
    end
  end
end
