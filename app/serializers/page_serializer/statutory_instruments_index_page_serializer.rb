module PageSerializer
  class StatutoryInstrumentsIndexPageSerializer < PageSerializer::BasePageSerializer
    def initialize(statutory_instruments: nil, request_id: nil)
      @statutory_instruments = statutory_instruments
      @request_id = request_id if request_id
    end

    private

    def meta
      { title: 'Statutory Instruments' }
    end

    def content
      [].tap do |content|
        content << ComponentSerializer::SectionComponentSerializer.new(section_primary_components, type: 'primary').to_h
        content << ComponentSerializer::SectionComponentSerializer.new(section_components, type: 'section').to_h
      end
    end

    def section_primary_components
      [ComponentSerializer::Heading1ComponentSerializer.new({ heading_content: 'Statutory Instruments' }).to_h]
    end

    def section_components
      [ComponentSerializer::ListComponentSerializer.new(display: 'generic', display_data: [display_data(component: 'list', variant: 'block')], components: statutory_instruments).to_h]
    end

    def statutory_instruments
      @statutory_instruments.map do |statutory_instrument|
        ComponentSerializer::LinkComponentSerializer.new(link: statutory_instruments_path(statutory_instrument.graph_id), content: statutory_instrument.name).to_h
      end
    end
  end
end
