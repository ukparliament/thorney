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
      @statutory_instrument.try(:statutoryInstrumentPaperName)
    end

    def heading1_component
      ComponentSerializer::Heading1ComponentSerializer.new({ subheading_content: 'statutory-instruments.show.subheading', heading_content: title, context_content: "#{@statutory_instrument.try(:statutoryInstrumentPaperPrefix)} #{@statutory_instrument.try(:statutoryInstrumentPaperYear)}/#{@statutory_instrument.try(:statutoryInstrumentPaperNumber)}" }).to_h
    end

    def meta_info
      [].tap do |items|
        web_link = @laid_thing.try(:workPackagedThingHasWorkPackagedThingWebLink)
        items << create_description_list_item('laid-thing.web-link', [link_to(web_link, web_link)]) if web_link

        items << create_description_list_item('statutory-instruments.show.made-date', [l(@statutory_instrument.made_date)])
        items << create_description_list_item('laid-thing.laid-date', [l(@laid_thing&.laying&.date)])
        items << create_description_list_item('statutory-instruments.show.coming-into-force-date', [l(@statutory_instrument.coming_into_force_date)])
        items << create_description_list_item('statutory-instruments.show.coming-into-force-note', [@statutory_instrument.try(:statutoryInstrumentPaperComingIntoForceNote)])
        items << create_description_list_item('statutory-instruments.show.following-title', connected_statutory_instruments)
        items << create_description_list_item('laid-thing.laying-person', [@laying_person&.display_name])
        items << create_description_list_item('laid-thing.laying-body', [@laying_body.try(:groupName)])
      end.compact
    end

    def connected_statutory_instruments
      @preceding_proposed_negative_statutory_instruments.map do |stat_instrument|
        link_to(stat_instrument.try(:proposedNegativeStatutoryInstrumentPaperName), proposed_negative_statutory_instrument_path(stat_instrument.graph_id))
      end
    end
  end
end
