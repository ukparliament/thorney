module PageSerializer
  class GroupsShowPageSerializer < PageSerializer::BasePageSerializer
    # Initialise a Groups show page serializer.
    #
    # @param [ActionDispatch::Request] request the current request object.
    # @param [<Grom::Node>] group a Grom::Node object of type StatutoryInstrumentPaper.
    # @param [Array<Hash>] data_alternates array containing the href and type of the alternative data urls.
    def initialize(request: nil, group: nil, data_alternates: nil)
      @group = group
      @layings = @group.try(:layingBodyHasLaying)
      @layings = @layings.sort_by(&:date).reverse if @layings != nil
      super(request: request, data_alternates: data_alternates)
    end

    private

    def meta
      super(title: title)
    end

    def title
      @group.try(:groupName)
    end

    def content
      [].tap do |components|
        components << ComponentSerializer::SectionComponentSerializer.new(components: section_primary_components, type: 'primary').to_h
        components << ComponentSerializer::SectionComponentSerializer.new(components: section_literals, type: 'section').to_h
      end
    end

    def section_primary_components
      [ComponentSerializer::Heading1ComponentSerializer.new(heading_content).to_h]
    end

    def heading_content
      {}.tap do |hash|
        hash[:subheading_content] = 'groups.group'
        hash[:subheading_data] = { link: groups_path }
        hash[:heading_content] = title
        hash[:context_content] = @group.date_range
      end
    end

    def section_literals
      [].tap do |components|
        components << ComponentSerializer::HeadingComponentSerializer.new(content: 'Literals', size: 2).to_h
        components << ComponentSerializer::ListDescriptionComponentSerializer.new(items: literals).to_h
        components << ComponentSerializer::HeadingComponentSerializer.new(content: 'Objects', size: 2).to_h
        components << if @group.is_a?(Parliament::Grom::Decorator::LayingBody) && @layings
                        ComponentSerializer::ListComponentSerializer.new(display: 'generic', display_data: [display_data(component: 'list', variant: 'block')], components: objects).to_h
                      end
      end
    end

    def literals
      [].tap do |items|
        items << { 'term': { 'content': 'Name' }, 'description': [{ 'content': @group.groupName }] }
        items << { 'term': { 'content': 'Start Date' }, 'description': [{ 'content': l(@group.start_date) }] } if @group.try(:groupStartDate)
        items << { 'term': { 'content': 'End Date' }, 'description': [{ 'content': l(@group.end_date) }] } if @group.try(:groupEndDate)
      end.compact
    end

    def objects
      @layings.map do |laying|
        ComponentSerializer::CardComponentSerializer.new(name: 'card__generic', data: { card_type: 'small', heading: card_heading(laying), paragraph: card_paragraph(laying) }).to_h
      end
    end

    def card_heading(laying)
      ComponentSerializer::HeadingComponentSerializer.new(content: laying.laid_thing.try(:laidThingName), size: 2, link: statutory_instrument_path(laying.laid_thing.graph_id)).to_h
    end

    def card_paragraph(laying)
      ComponentSerializer::ParagraphComponentSerializer.new(content: [{ content: "Laying date: #{l(laying.date)}" }]).to_h
    end
  end
end
