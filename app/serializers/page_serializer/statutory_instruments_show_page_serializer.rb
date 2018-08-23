module PageSerializer
  class StatutoryInstrumentsShowPageSerializer < PageSerializer::BasePageSerializer
    def initialize(statutory_instrument: nil, request_id: nil)
      @statutory_instrument       = statutory_instrument
      @request_id                 = request_id if request_id
      @work_package = @statutory_instrument&.work_package
      @preceding_proposed_negative_statutory_instruments = @statutory_instrument.proposed_negative_statutory_instrument_papers
      @laying_body = @statutory_instrument&.laying&.body
      @laying_person = @statutory_instrument&.laying&.person
      @procedure = @work_package&.procedure if @work_package
    end

    private

    attr_reader :request_id

    def meta
      { title: @statutory_instrument.name }
    end

    def content
      [].tap do |components|
        components << ComponentSerializer::SectionComponentSerializer.new(section_primary_components, type: 'primary').to_h
        components << ComponentSerializer::SectionComponentSerializer.new(section_description_list('statutory-instruments.show.literals', statutory_instruments_literals), type: 'section').to_h
        components << ComponentSerializer::SectionComponentSerializer.new(section_list('statutory-instruments.show.preceding-title', preceding_proposed_negative_statutory_instruments), type: 'section').to_h
        components << ComponentSerializer::SectionComponentSerializer.new(section_description_list('statutory-instruments.show.objects', statutory_instruments_objects), type: 'section').to_h
      end
    end

    def section_primary_components
      [ComponentSerializer::Heading1ComponentSerializer.new({ heading_content: @statutory_instrument.name }).to_h]
    end

    def section_description_list(title, list_content)
      [].tap do |components|
        components << ComponentSerializer::HeadingComponentSerializer.new(content: title, size: 2).to_h
        components << ComponentSerializer::ListDescriptionComponentSerializer.new(items: list_content).to_h
      end
    end

    def section_list(title, list_content)
      [].tap do |components|
        components << ComponentSerializer::HeadingComponentSerializer.new(content: title, size: 2).to_h
        components << ComponentSerializer::ListComponentSerializer.new(display: 'generic', display_data: [display_data(component: 'list')], components: list_content).to_h
      end
    end

    def statutory_instruments_literals
      [].tap do |items|
        items << create_description_list_item('statutory-instruments.show.prefix', [@statutory_instrument.prefix])
        items << create_description_list_item('statutory-instruments.show.year', [@statutory_instrument.year])
        items << create_description_list_item('statutory-instruments.show.number', [@statutory_instrument.number])
        items << create_description_list_item('statutory-instruments.show.laid-date', [localize(@statutory_instrument&.laying&.date)])
        items << create_description_list_item('statutory-instruments.show.coming-into-force-date', [localize(@statutory_instrument.coming_into_force_date)])
        items << create_description_list_item('statutory-instruments.show.coming-into-force-note', [@statutory_instrument.coming_into_force_note])
        items << create_description_list_item('statutory-instruments.show.made-date', [localize(@statutory_instrument.made_date)])
      end
    end

    def statutory_instruments_objects
      [].tap do |items|
        items << create_description_list_item('statutory-instruments.show.web-link', ["<a href='#{@statutory_instrument.web_link}'>#{@statutory_instrument.web_link}</a>"])
        items << create_description_list_item('statutory-instruments.show.work-package', ["<a href='/work-packages/#{@work_package&.graph_id}'>#{@work_package&.graph_id}</a>"])
        items << create_description_list_item('statutory-instruments.show.procedure', ["<a href='/procedures/#{@procedure&.graph_id}'>#{@procedure&.name}</a>"])
        items << create_description_list_item('statutory-instruments.show.laying-body', [@laying_body&.name])
        items << create_description_list_item('statutory-instruments.show.laying-person', [@laying_person&.display_name])
      end
    end

    def preceding_proposed_negative_statutory_instruments
      @preceding_proposed_negative_statutory_instruments.map do |stat_instrument|
        ComponentSerializer::LinkComponentSerializer.new(
          link:    "/proposed-negative-statutory-instruments/#{stat_instrument.graph_id}",
          content: stat_instrument.name
        ).to_h
      end
    end
  end
end
