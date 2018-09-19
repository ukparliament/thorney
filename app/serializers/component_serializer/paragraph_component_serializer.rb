module ComponentSerializer
  class ParagraphComponentSerializer < ComponentSerializer::BaseComponentSerializer
    # Initialise a paragraph component with one or more pieces of content.
    #
    # @param [Array<Hash>] content one or more pieces of content to be wrapped in <p> tags. The hashes have a content key and and optional link key.
    #
    # @example Initialising a paragraph component
    #  string_or_translation_key = 'Here is some paragraph text'
    #  link = 'beta.parliament.uk'
    #  ComponentSerializer::ParagraphComponentSerializer.new(content: [{ content: string_or_translation_key, link: link }]).to_h
    def initialize(content: nil)
      @content = content
    end

    private

    def name
      'paragraph'
    end

    def data
      @content.map do |content|
        {}.tap do |hash|
          hash[:content] = content[:content]
          hash[:data] = { link: content[:link] } if content[:link]
        end
      end
    end
  end
end
