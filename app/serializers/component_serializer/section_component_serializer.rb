module ComponentSerializer
  class SectionComponentSerializer < ComponentSerializer::BaseComponentSerializer
    # Initialise a section component with an array of objects.
    #
    # @param [Array<Hash>] components an array of objects, each object is a component or atom.
    # @param [String] type the type of section required - can be section or primary.
    # @param [boolean] content_flag an optional parameter which adds a content-flag property to data.
    def initialize(components, type: 'section', content_flag: nil)
      @content_flag = content_flag
      @type = type
      @components = components
    end

    private

    def name
      "section__#{@type}"
    end

    def data
      {}.tap do |hash|
        hash[:content_flag] = @content_flag if @content_flag
        hash[:components] = @components
      end
    end
  end
end
