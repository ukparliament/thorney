module ComponentSerializer
  class ParagraphComponentSerializer < ComponentSerializer::BaseComponentSerializer
    # Initialise a paragraph component with one or more pieces of content.
    #
    # @param [Array<Hash>] content one or more pieces of content to be wrapped in <p> tags. The hashes have a content key and any other optional keys.
    #
    # @example Initialising a paragraph component
    #  string_or_translation_key = 'Here is some paragraph text'
    #  link = 'beta.parliament.uk'
    #  ComponentSerializer::ParagraphComponentSerializer.new(content: [{ content: string_or_translation_key, link: link }]).to_h
    #
    # @example You can also add custom properties for use with translations on the front end
    #  hash = { content: 'some content', date: '14 May 2018', type: 'Statutory Instrument' }
    #  ComponentSerializer::ParagraphComponentSerializer.new(content: [hash]).to_h
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

          data = content.try(:except, :content)

          hash[:data] = data if data.present?
        end
      end
    end
  end
end
