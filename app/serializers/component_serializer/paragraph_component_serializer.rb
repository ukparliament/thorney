module ComponentSerializer
  class ParagraphComponentSerializer < ComponentSerializer::BaseComponentSerializer
    # Initialise a paragraph component with one or more pieces of content.
    #
    # @param [Array<Hash>] content one or more pieces of content to be wrapped in <p> tags. The hashes have a content key and any other optional keys.
    #
    # @example Initialising a paragraph component with only a string or translation key
    #  string_or_translation_key = 'Here is some paragraph text'
    #  ComponentSerializer::ParagraphComponentSerializer.new(content: [{ content: string_or_translation_key }, { content: string_or_translation_key }]).to_h
    #
    # @example Initialising a paragraph component with a translation key and data to be interpolated you must use the ContentDataHelper
    #  ComponentSerializer::ParagraphComponentSerializer.new(content: [ContentDataHelper.content_data(content: 'some content', one: 'property', yet: 'another'), ContentDataHelper.content_data(content: 'some content', one: 'property', yet: 'another')]).to_h
    def initialize(content: nil)
      @content = content
    end

    private

    def name
      'paragraph'
    end

    def data
      @content if @content
    end
  end
end
