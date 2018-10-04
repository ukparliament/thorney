module PageSerializer
  class StatutoryInstrumentsShowPageSerializer < LaidThingShowPageSerializer
    # Initialise a Statutory Instruments show page serializer.
    #
    # @param [ActionDispatch::Request] request the current request object.
    # @param [<Grom::Node>] statutory_instrument a Grom::Node object of type StatutoryInstrumentPaper.
    # @param [Array<Hash>] data_alternates array containing the href and type of the alternative data urls.
    def initialize(request: nil, statutory_instrument:, data_alternates: nil)
      @statutory_instrument                              = statutory_instrument
      @preceding_proposed_negative_statutory_instruments = @statutory_instrument.proposed_negative_statutory_instrument_papers

      super(request: request, laid_thing: @statutory_instrument, data_alternates: data_alternates)
    end

    private

    def meta
      super(title: title)
    end

    def title
      @statutory_instrument.name
    end

    def content
      [].tap do |components|
        components << ComponentSerializer::SectionComponentSerializer.new(components: section_primary_components, type: 'primary').to_h
        components << ComponentSerializer::SectionComponentSerializer.new(components: section_literals, type: 'section').to_h
        components << ComponentSerializer::SectionComponentSerializer.new(components: section_objects, type: 'section').to_h
      end
    end

    def section_primary_components
      [ComponentSerializer::Heading1ComponentSerializer.new({ subheading_content: 'statutory-instruments.show.subheading', heading_content: title, context_content: "#{@statutory_instrument.prefix} #{@statutory_instrument.year}/#{@statutory_instrument.number}" }).to_h]
    end

    def section_literals
      [].tap do |components|
        components << ComponentSerializer::HeadingComponentSerializer.new(content: 'statutory-instruments.show.literals', size: 2).to_h
        components << ComponentSerializer::ListDescriptionComponentSerializer.new(items: literals).to_h
      end
    end

    def literals
      [].tap do |items|
        items << create_description_list_item('statutory-instruments.show.made-date', [l(@statutory_instrument.made_date)])
        items << create_description_list_item('statutory-instruments.show.coming-into-force-note', [@statutory_instrument.coming_into_force_note])
        items << create_description_list_item('statutory-instruments.show.coming-into-force-date', [l(@statutory_instrument.coming_into_force_date)])
      end.compact
    end

    def connected_statutory_instruments
      @preceding_proposed_negative_statutory_instruments.map do |stat_instrument|
        ComponentSerializer::LinkComponentSerializer.new(
          link:    proposed_negative_statutory_instrument_path(stat_instrument.graph_id),
          content: stat_instrument.name
        ).to_h
      end
    end

    def connected_statutory_instruments_title
      'statutory-instruments.show.following-title'
    end
  end
end
