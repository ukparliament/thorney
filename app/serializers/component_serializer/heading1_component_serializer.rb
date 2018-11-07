module ComponentSerializer
  class Heading1ComponentSerializer < ComponentSerializer::BaseComponentSerializer
    # Initialise a heading1 component.
    #
    # @param [Hash | String] subheading content of the subheading, this could be a string/ translation key or a content data hash.
    # @param [String] subheading_link link for the subheading, providing this will wrap the subheading in <a> tags
    # @param [Hash | String] heading content of the heading, this could be a string/ translation key or a content data hash.
    # @param [Hash | String] context content of the context, this could be a string/ translation key or a content data hash.
    # @param [Boolean] context_hidden this boolean indicated if the context is only available to screen readers.
    #
    # @example Initialising a heading1 component with content
    #  string_or_translation_key = 'Here are the headings'
    #  link = 'parliament.uk'
    #  boolean = true
    #  ComponentSerializer::Heading1ComponentSerializer.new(subheading: string_or_translation_key, subheading_link: link, heading: string_or_translation_key, context: string_or_translation_key, context_hidden: boolean).to_h
    # @example Initialising a heading1 component with content and data
    #  content_data_helper = ContentDataHelper.content_data(content: 'Dianne Abbott', link: 'www.dianneabbott.com')
    #  link = 'parliament.uk'
    #  boolean = true
    #  ComponentSerializer::Heading1ComponentSerializer.new(subheading: content_data_helper, subheading_link: link, heading: content_data_helper, context: content_data_helper, context_hidden: boolean).to_h
    def initialize(subheading: nil, subheading_link: nil, heading: nil, context: nil, context_hidden: nil)
      @subheading = subheading.is_a?(Hash) ? subheading : { content: subheading }
      @subheading_link = subheading_link
      @heading = heading.is_a?(Hash) ? heading : { content: heading }
      @context = context.is_a?(Hash) ? context : { content: context }
      @context_hidden = context_hidden
    end

    def to_s
      return "#{@subheading[:content]} - #{@heading[:content]}" unless @subheading[:content].nil?

      @heading[:content] || t('no_name')
    end

    private

    def name
      'heading1'
    end

    def data
      {}.tap do |hash|
        hash[:subheading] = subheading if @subheading[:content]
        hash[:heading] = @heading if @heading[:content]
        hash[:context] = @context if @context[:content] && !@context_hidden
        hash[:context] = context_hidden if @context[:content] && @context_hidden
      end
    end

    def subheading
      @subheading[:content] = @subheading_link ? link_to(@subheading[:content], @subheading_link) : @subheading[:content]
      @subheading
    end

    def context_hidden
      @context[:hidden] = @context_hidden
      @context
    end
  end
end
