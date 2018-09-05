module ComponentSerializer
  # Creates a description list using the array of objects passed to it.
  class ListDescriptionComponentSerializer < ComponentSerializer::BaseComponentSerializer
    # Initialise a list component with an array of objects.
    #
    # @param [Array<Hash>] items an array of objects.
    #
    # @example Creating a description list component
    #   ComponentSerializer::ListDescriptionComponentSerializer.new(
    # "items":
    # [{
    #    "term":
    #      {
    #        "content": "telephone"
    #      },
    #    "description":
    #      [
    #        {
    #          "content": "020 1234 567"
    #        }
    #      ]
    #  },
    #  {
    #    "term":
    #      {
    #        "content": "website"
    #      },
    #    "description":
    #      [
    #        {
    #          "content": "<a href='www.example.com'>My home page</a>"
    #        }
    #      ]
    #  },
    #  {
    #    "term":
    #      {
    #        "content": "email"
    #      },
    #    "description":
    #      [
    #        {
    #          "content": "hello@example.com"
    #        },
    #        {
    #          "content": "hello@gmail.com"
    #        }
    #      ]
    #  }
    # ])
    #
    def initialize(items: nil)
      @items = items
    end

    private

    def name
      'list__description'
    end

    def data
      {}.tap do |hash|
        hash[:items] = @items if @items
      end
    end
  end
end
