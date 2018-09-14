module PageSerializer
  class StatutoryInstrumentsIndexPageSerializer < PageSerializer::BasePageSerializer
    # Initialise a Statutory Instruments index page serializer.
    #
    # @param [Array<Grom::Node>] statutory_instruments an array of Grom::Node objects of type StatutoryInstrumentPaper.
    # @param [String] request_id AppInsights request id
    # @param [Array<Hash>] data_alternates array containing the href and type of the alternative data urls
    # @param [String] request_original_url original url of the request
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
