module PageSerializer
  class StatutoryInstrumentsShowPageSerializer < PageSerializer::BasePageSerializer
    # Initialise a Statutory Instruments index page serializer.
    #
    # @param [<Grom::Node>] statutory_instrument a Grom::Node object of type StatutoryInstrumentPaper.
    # @param [String] request_id AppInsights request id
    # @param [Array<Hash>] data_alternates array containing the href and type of the alternative data urls
    # @param [String] request_original_url original url of the request
    def initialize(statutory_instrument:, request_id: nil, data_alternates: nil, request_original_url: nil)
      @statutory_instrument                              = statutory_instrument
      @work_package                                      = @statutory_instrument.work_package
      @preceding_proposed_negative_statutory_instruments = @statutory_instrument.proposed_negative_statutory_instrument_papers
      @laying_body                                       = @statutory_instrument&.laying&.body
      @laying_person                                     = @statutory_instrument&.laying&.person
      @procedure                                         = @work_package&.procedure

      super(request_id: request_id, data_alternates: data_alternates, request_original_url: request_original_url)
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
        components << ComponentSerializer::SectionComponentSerializer.new(section_primary_components, type: 'primary').to_h
        components << ComponentSerializer::SectionComponentSerializer.new(section_literals, type: 'section').to_h
        components << ComponentSerializer::SectionComponentSerializer.new(section_objects, type: 'section').to_h
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

    def section_objects
      [].tap do |components|
        components << ComponentSerializer::HeadingComponentSerializer.new(content: 'statutory-instruments.show.objects', size: 2).to_h
        components << parent_child_objects
        components << ComponentSerializer::HeadingComponentSerializer.new(content: 'statutory-instruments.show.following-title', size: 3).to_h
        components << ComponentSerializer::ListComponentSerializer.new(display: 'generic', display_data: [display_data(component: 'list')], components: proposed_negative_statutory_instruments).to_h
      end.flatten
    end

    def parent_child_objects
      [].tap do |components|
        components << object_heading_paragraph(3, 'statutory-instruments.show.work-package', "<a href='/work-packages/#{@work_package&.graph_id}'>#{@work_package&.graph_id}</a>")
        components << object_heading_paragraph(4, 'statutory-instruments.show.procedure', "<a href='/procedures/#{@procedure&.graph_id}'>#{@procedure&.name}</a>")
        components << object_heading_paragraph(3, 'statutory-instruments.show.laying', @statutory_instrument&.laying&.graph_id)
        components << object_heading_paragraph(4, 'statutory-instruments.show.laid-date', l(@statutory_instrument&.laying&.date))
        components << object_heading_paragraph(4, 'statutory-instruments.show.laying-body', @laying_body&.name)
        components << object_heading_paragraph(4, 'statutory-instruments.show.laying-person', @laying_person&.display_name)
        components << object_heading_paragraph(3, 'statutory-instruments.show.web-link', "<a href='#{@statutory_instrument.web_link}'>#{@statutory_instrument.web_link}</a>")
      end.flatten
    end

    def object_heading_paragraph(heading_size, heading_content, paragraph_content)
      [].tap do |components|
        components << ComponentSerializer::HeadingComponentSerializer.new(content: heading_content, size: heading_size).to_h
        components << ComponentSerializer::ParagraphComponentSerializer.new([{ content: paragraph_content }]).to_h
      end
    end

    def proposed_negative_statutory_instruments
      @preceding_proposed_negative_statutory_instruments.map do |stat_instrument|
        ComponentSerializer::LinkComponentSerializer.new(
          link:    "/proposed-negative-statutory-instruments/#{stat_instrument.graph_id}",
          content: stat_instrument.name
        ).to_h
      end
    end
  end
end
