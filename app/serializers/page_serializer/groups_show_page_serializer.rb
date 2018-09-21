module PageSerializer
  class GroupsShowPageSerializer < PageSerializer::BasePageSerializer
    # Initialise a Groups show page serializer.
    #
    # @param [<Grom::Node>] group a Grom::Node object of type StatutoryInstrumentPaper.
    # @param [String] request_id AppInsights request id
    # @param [Array<Hash>] data_alternates array containing the href and type of the alternative data urls
    # @param [String] request_original_url original url of the request
    def initialize(group: nil, request_id: nil, data_alternates: nil, request_original_url: nil)
      @group = group

      super(request_id: request_id, data_alternates: data_alternates, request_original_url: request_original_url)
    end

    private

    def meta
      { title: title }
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
        hash[:subheading_content] = 'Group'
        hash[:heading_content] = title
        hash[:context_content] = date_range if @group.try(:groupStartDate)
      end
    end

    def date_range
      start_date = l(DateTime.parse(@group.try(:groupStartDate))) if @group.try(:groupStartDate)
      end_date = l(DateTime.parse(@group.try(:groupEndDate))) if @group.try(:groupEndDate)
      "#{start_date} to #{end_date}"
    end

    def section_literals
      [].tap do |components|
        components << ComponentSerializer::HeadingComponentSerializer.new(content: 'Literals', size: 2).to_h
        components << ComponentSerializer::ListDescriptionComponentSerializer.new(items: literals).to_h
      end
    end

    def literals
      [].tap do |items|
        items << { 'term': { 'content': 'Name' }, 'description': [{ 'content': @group.groupName }] } if @group.try(:groupName)
        items << { 'term': { 'content': 'Start Date' }, 'description': [{ 'content': l(DateTime.parse(@group.groupStartDate)) }] } if @group.try(:groupStartDate)
        items << { 'term': { 'content': 'End Date' }, 'description': [{ 'content': l(DateTime.parse(@group.groupEndDate)) }] } if @group.try(:groupEndDate)
      end.compact
    end
  end
end
