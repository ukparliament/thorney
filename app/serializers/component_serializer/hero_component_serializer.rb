module ComponentSerializer
  class HeroComponentSerializer < BaseComponentSerializer
    # Initialise a hero component with an array of objects.
    #
    # @param [Array<Hash>] components an array of objects, each object is a component or partial.
    # @param [boolean] content_flag an optional parameter which adds a content-flag property to data.
    #
    # @example Initialising a hero component
    #  a_serializer = ComponentSerializer::Heading1ComponentSerializer.new(heading_content: 'Hero Section Heading').to_h
    #  boolean = true
    #  ComponentSerializer::HeroComponentSerializer.new([a_serializer], content_flag: boolean).to_h
    def initialize(components: nil, content_flag: nil)
      @components = components
      @content_flag = content_flag
    end

    def name
      'hero'
    end

    def data
      {}.tap do |hash|
        hash[:content_flag] = @content_flag if @content_flag
        hash[:components] = @components
      end
    end
  end
end
