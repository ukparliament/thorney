module ComponentSerializer
  # Creates a description list using the array of objects passed to it.
  class ListDescriptionComponentSerializer < ComponentSerializer::BaseComponentSerializer
    # Initialise a list component with an array of objects.
    #
    # @param [Array<Hash>] items an array of objects.
    # @param [Boolean] meta is this description list used for meta information?
    #
    # @example Creating a description list component
    #  To create a description list item you should use the ListDescriptionHelper, and for translation strings with data for interploation use the ContentDataHelper.
    #  string_or_translation_key = 'List item'
    #  ComponentSerializer::ListDescriptionComponentSerializer.new(
    #    items: [
    #      create_description_list_item(string_or_translation_key, [first_bit_of_data: "Data 1")]),
    #      create_description_list_item(
    #        ContentDataHelper.content_data(content: 'translation_key_1', first_bit_of_data: "Data 1", second_bit_of_data: "Data 2"),
    #        [
    #          ContentDataHelper.content_data(content: 'translation_key_2', first_bit_of_data: "Data 3", second_bit_of_data: "Data 4"),
    #          ContentDataHelper.content_data(content: 'translation_key_3', first_bit_of_data: "Data 5", second_bit_of_data: "Data 6")
    #        ]
    #      )
    #
    #    ]
    #  ).to_h
    #
    # @example Creating a description list component with a meta tag
    #  meta_tag = true
    #  string_or_translation_key = 'List item'
    #  ComponentSerializer::ListDescriptionComponentSerializer.new(meta: meta_tag, items: [{ 'term': { 'content': string_or_translation_key }, 'description': [{ 'content': string_or_translation_key }] }, { 'term': { 'content': string_or_translation_key }, 'description': [{ 'content': string_or_translation_key }] }]).to_h
    def initialize(items: nil, meta: false)
      @items = items
      @meta  = meta
    end

    private

    def name
      'list__description'
    end

    def data
      {}.tap do |hash|
        hash[:meta]  = @meta  if @meta
        hash[:items] = @items if @items
      end
    end
  end
end
