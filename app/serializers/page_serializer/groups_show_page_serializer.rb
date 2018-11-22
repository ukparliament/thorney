module PageSerializer
  class GroupsShowPageSerializer < PageSerializer::BasePageSerializer
    # Initialise a Groups show page serializer.
    #
    # @param [ActionDispatch::Request] request the current request object.
    # @param [<Grom::Node>] group a Grom::Node object of type Group.
    # @param [Array<Hash>] data_alternates array containing the href and type of the alternative data urls.
    def initialize(request: nil, group: nil, data_alternates: nil)
      @group = group
      super(request: request, data_alternates: data_alternates)
    end

    private

    def meta
      super(title: title)
    end

    def title
      @group.try(:groupName) || t('no_name')
    end

    def content
      [].tap do |components|
        components << ComponentSerializer::SectionComponentSerializer.new(components: section_primary_components, type: 'primary', content_flag: true).to_h
        components << ComponentSerializer::SectionComponentSerializer.new(components: section_components, type: 'section').to_h
      end
    end

    def section_primary_components
      [].tap do |component|
        component << ComponentSerializer::Heading1ComponentSerializer.new(heading_content).to_h
      end
    end

    def heading_content
      {}.tap do |hash|
        hash[:subheading] = ContentDataHelper.content_data(content: 'groups.groups', link: groups_path)
        hash[:heading] = title
      end
    end

    def list_components
      section_components = []

      if @group.is_a?(Parliament::Grom::Decorator::LayingBody)
        section_components << CardFactory.new(heading_text: 'groups.subsidiary-resources.layings', heading_translation_url: group_made_available_availability_types_laid_papers_path(@group.try(:graph_id))).build_card
      end

      section_components
    end

    def section_components
      [ComponentSerializer::ListComponentSerializer.new(display: 'generic', display_data: [display_data(component: 'list', variant: 'block')], components: list_components).to_h]
    end
  end
end
