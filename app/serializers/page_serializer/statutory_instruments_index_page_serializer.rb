module PageSerializer
  class StatutoryInstrumentsIndexPageSerializer < PageSerializer::BasePageSerializer
    def initialize(statutory_instruments:, request_id: nil, data_alternates: nil, request_original_url: nil)
      @statutory_instruments = statutory_instruments
      @data_alternates = data_alternates

      super(request_id: request_id, data_alternates: data_alternates, request_original_url: request_original_url)
    end

    private

    def meta
      super(title: title)
    end

    def title
      'statutory-instruments.index.title'
    end

    def content
      [].tap do |content|
        content << ComponentSerializer::SectionComponentSerializer.new(section_primary_components, type: 'primary').to_h
        content << ComponentSerializer::SectionComponentSerializer.new(section_components, type: 'section').to_h
      end
    end

    def section_primary_components
      [ComponentSerializer::Heading1ComponentSerializer.new({ heading_content: title }).to_h]
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
