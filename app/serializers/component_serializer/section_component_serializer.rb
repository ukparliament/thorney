module ComponentSerializer
  class SectionComponentSerializer < ComponentSerializer::BaseComponentSerializer
    # Initialise a section component with an array of objects.
    #
    # @param [Array<Hash>] components an array of objects, each object is a component or atom.
    # @param [String] type the type of section required - can be section or primary.
    # @param [boolean] content_flag an optional parameter which adds a content-flag property to data.
    # @param [Array<Hash>] display_data used for the element's css.
    #
    # @example Initialising a section section component
    #  a_serializer = ComponentSerializer::HeadingComponentSerializer.new(content: ['This is a heading for a section section'], size: 2).to_h
    #  type_of_section = section
    #  boolean = true
    # display_data = [display_data(component: 'section')]
    #  ComponentSerializer::SectionComponentSerializer.new(components: [a_serializer], type: type_of_section, content_flag: boolean, display_data: display_data).to_h
    #
    # @example Initialising a section primary component
    #  a_serializer = ComponentSerializer::Heading1ComponentSerializer.new(heading_content: 'This is a heading for a section section').to_h
    #  type_of_section = primary
    #  boolean = true
    #  ComponentSerializer::SectionComponentSerializer.new([a_serializer], type: type_of_section, content_flag: boolean).to_h
    def initialize(components, type: 'section', content_flag: nil, display_data: nil)
      @content_flag = content_flag
      @type = type
      @components = components
      @display_data = display_data
    end

    private

    def name
      "section__#{@type}"
    end

    def data
      {}.tap do |hash|
        hash[:content_flag] = @content_flag if @content_flag
        hash[:display] = display_hash(@display_data) if @display_data
        hash[:components] = @components
      end
    end
  end
end
