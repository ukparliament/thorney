module ComponentSerializer
  class Heading1ComponentSerializer < ComponentSerializer::BaseComponentSerializer
    # Initialise a heading1 component.
    #
    # @param [String] content of the subheading, this could be a string or a translation key.
    # @param [String] data for the subheading, for example this could be an integer or url which can be passed into a translation in the front end.
    # @param [String] ontent of the heading, this could be a string or a translation key.
    # @param [String] data for the heading, for example this could be an integer or url which can be passed into a translation in the front end.
    # @param [String] content of the context, this could be a string or a translation key.
    # @param [String] data for the context, for example this could be an integer or url which can be passed into a translation in the front end.
    # @param [Boolean] this boolean indicated if the context is only avalibale to screen readers.
    def initialize(subheading_content: nil, subheading_data: nil, heading_content: nil, heading_data: nil, context_content: nil, context_data: nil, context_hidden: nil)
      @subheading_content = subheading_content
      @subheading_data = subheading_data
      @heading_content = heading_content
      @heading_data = heading_data
      @context_content = context_content
      @context_data = context_data
      @context_hidden = context_hidden
    end

    private

    def name
      'heading1'
    end

    def data
      {}.tap do |hash|
        hash[:subheading] = subheading if @subheading_content || @subheading_data
        hash[:heading] = heading if @heading_content || @heading_data
        hash[:context] = context if @context_content || @context_data
      end
    end

    def subheading
      {}.tap do |hash|
        hash[:content] =  @subheading_content if @subheading_content
        hash[:data] = @subheading_data if @subheading_data
      end
    end

    def heading
      {}.tap do |hash|
        hash[:content] = @heading_content if @heading_content
        hash[:data] = @heading_data if @heading_data
      end
    end

    def context
      {}.tap do |hash|
        hash[:content] = @context_content if @context_content
        hash[:data] = @context_data if @context_data
        hash[:hidden] = @context_hidden if @context_hidden
      end
    end

  end
end
