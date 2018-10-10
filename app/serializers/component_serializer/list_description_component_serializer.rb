module ComponentSerializer
  # Creates a description list using the array of objects passed to it.
  class ListDescriptionComponentSerializer < ComponentSerializer::BaseComponentSerializer
    # Initialise a list component with an array of objects.
    #
    # @param [Array<Hash>] items an array of objects.
    # @param [Boolean] meta is this description list used for meta information?
    #
    # @example Creating a description list component
    #  string_or_translation_key = 'List item'
    #  ComponentSerializer::ListDescriptionComponentSerializer.new(items: [{ 'term': { 'content': string_or_translation_key }, 'description': [{ 'content': string_or_translation_key }] }, { 'term': { 'content': string_or_translation_key }, 'description': [{ 'content': string_or_translation_key }] }]).to_h
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
