module PageSerializer
  class LayingsShowPageSerializer < LaidThingShowPageSerializer
    # Initialise a Laying show page.
    # @param [ActionDispatch::Request] request the current request object.
    # @param [<Grom::Node>] laying a Grom::Node object of type Laying.
    # @param [Array<Hash>] data_alternates array containing the href and type of the alternative data urls.
    def initialize(request: nil, laying:, data_alternates: nil)
      @laying = laying

      super(request: request, laid_thing: @laying.laid_thing, data_alternates: data_alternates)
    end

    private

    def meta
      super(title: title)
    end

    def title
      @laying.procedure_step.try(:procedureStepName)
    end

    def heading1_component
      ComponentSerializer::Heading1ComponentSerializer.new(heading_content).to_h
    end

    def heading_content
      {}.tap do |hash|
        hash[:subheading] = ContentDataHelper.content_data(content: 'laid-thing.laid-papers', link: laid_papers_path)
        hash[:heading] = title || t('no_name')
      end
    end

    def meta_info
      [].tap do |items|
        web_link = @laying.try(:businessItemHasBusinessItemWebLink)
        items << create_description_list_item(term: 'laid-thing.laid-paper', descriptions: [link_to(@laying.laid_thing.try(:laidThingName), laid_thing_type[:rails_path])])
        items << create_description_list_item(term: 'laid-thing.web-link', descriptions: [link_to(web_link, web_link)]) if web_link
        items << create_description_list_item(term: 'laid-thing.laid-paper-type', descriptions: [laid_thing_type[:translation_key]])
        items << create_description_list_item(term: 'laid-thing.laid-date', descriptions: [TimeHelper.time_translation(date_first: @laying&.date)]) if @laying&.date
        items << create_description_list_item(term: 'laid-thing.laying-body', descriptions: [link_to(@laying.body.groupName, group_path(@laying.body.graph_id))]) if @laying.body
      end.compact
    end

    def laid_thing_type
      if @laying.laid_thing.is_a?(Parliament::Grom::Decorator::StatutoryInstrumentPaper)
        statutory_instrument_hash
      elsif @laying.laid_thing.is_a?(Parliament::Grom::Decorator::ProposedNegativeStatutoryInstrumentPaper)
        proposed_negative_statutory_instrument_hash
      end
    end

    def statutory_instrument_hash
      {
        rails_path:      statutory_instrument_path(@laying.laid_thing.graph_id),
        translation_key: 'statutory-instruments.type'
      }
    end

    def proposed_negative_statutory_instrument_hash
      {
        rails_path:      proposed_negative_statutory_instrument_path(@laying.laid_thing.graph_id),
        translation_key: 'proposed-negative-statutory-instruments.type'
      }
    end

    def work_package_card_heading
      ComponentSerializer::HeadingComponentSerializer.new(content: link_to(@laying.laid_thing.try(:laidThingName), work_package_path(@laying.laid_thing.try(:graph_id))), size: 2).to_h
    end
  end
end
