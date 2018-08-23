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

    def meta
      { title: @statutory_instrument.name }
    end

    def content
      [].tap do |content|
        content << ComponentSerializer::SectionComponentSerializer.new(section_primary_components, type: 'primary').to_h
        content << ComponentSerializer::SectionComponentSerializer.new(section_components, type: 'section').to_h
      end
    end

    def section_primary_components
      [ComponentSerializer::Heading1ComponentSerializer.new({ heading_content: @statutory_instrument.name }).to_h]
    end

    def section_components
      [ComponentSerializer::ListComponentSerializer.new(display: 'generic', display_data: [display_data(component: 'list', variant: 'block')], components: statutory_instrument_components).to_h]
    end

    def statutory_instrument_components
      [].tap do |components|
        components << ComponentSerializer::HeadingComponentSerializer.new(content: 'Literals', size: 2).to_h
        components << ComponentSerializer::ListComponentSerializer.new(display: 'generic', display_data: [display_data(component: 'list')], contents: statutory_instruments_literals).to_h

        unless @preceding_proposed_negative_statutory_instruments.empty?
          components << ComponentSerializer::HeadingComponentSerializer.new(content: 'Preceded by Negative Statutory Instruments', size: 2).to_h
          components << ComponentSerializer::ListComponentSerializer.new(display: 'generic', display_data: [display_data(component: 'list')], components: preceding_proposed_negative_statutory_instruments).to_h
        end

        components << ComponentSerializer::HeadingComponentSerializer.new(content: 'Links', size: 2).to_h
        components << ComponentSerializer::ListComponentSerializer.new(display: 'generic', display_data: [display_data(component: 'list')], components: statutory_instruments_link_components).to_h
      end
    end

    def statutory_instruments_literals
      [].tap do |content|
        content << "Prefix - #{@statutory_instrument.prefix}"
        content << "Year - #{@statutory_instrument.year}"
        content << "Number - #{@statutory_instrument.number}"
        content << "Coming into force date - #{I18n.l(@statutory_instrument.coming_into_force_date)}" unless @statutory_instrument.coming_into_force_date.nil?
        content << "Coming into force note - #{@statutory_instrument.coming_into_force_note}"
        content << "Made date - #{I18n.l(@statutory_instrument.made_date)}" unless @statutory_instrument.made_date.nil?
      end
    end

    def statutory_instruments_link_components
      [].tap do |components|
        unless @statutory_instrument.web_link.empty?
          components << ComponentSerializer::LinkComponentSerializer.new(
            link:    @statutory_instrument.web_link,
            content: 'Web Link'
          ).to_h
        end

        if @work_package
          components << ComponentSerializer::LinkComponentSerializer.new(
            link:    work_package_path(@work_package&.graph_id),
            content: 'Work Package'
          ).to_h
        end

        if @procedure
          components << ComponentSerializer::LinkComponentSerializer.new(
            link:    procedure_path(@procedure.graph_id),
            content: @procedure.name
          ).to_h
        end

        if @laying_body
          components << ComponentSerializer::LinkComponentSerializer.new(
            link:    group_path(@statutory_instrument.laying.body.graph_id),
            content: @laying_body.name
          ).to_h

        end

        if @laying_person
          components << ComponentSerializer::LinkComponentSerializer.new(
            link:    person_path(@statutory_instrument.laying.person.graph_id),
            content: @laying_person.display_name
          ).to_h
        end
      end
    end

    def preceding_proposed_negative_statutory_instruments
      # Change line 90 - should be proposed_negative_statutory_instrument_path
      @preceding_proposed_negative_statutory_instruments.map do |stat_instrument|
        ComponentSerializer::LinkComponentSerializer.new(
          link:    "/proposed-negative-statutory-instruments/#{stat_instrument.graph_id}",
          content: stat_instrument.name
        ).to_h
      end
    end
  end
end
