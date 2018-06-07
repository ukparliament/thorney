module ComponentSerializer
  # A search icon component.
  class SearchIconComponentSerializer < ComponentSerializer::BaseComponentSerializer
    private

    def name
      'icon__search'
    end

    def data
      'search.search-icon'
    end
  end
end
