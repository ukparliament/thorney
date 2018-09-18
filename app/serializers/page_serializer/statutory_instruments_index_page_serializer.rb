module PageSerializer
  class StatutoryInstrumentsIndexPageSerializer < ListPageSerializer
    # Initialise a Statutory Instruments index page serializer.
    #
    # @param [Array<Grom::Node>] statutory_instruments an array of Grom::Node objects of type StatutoryInstrumentPaper.
    # @param [String] request_id AppInsights request id
    # @param [Array<Hash>] data_alternates array containing the href and type of the alternative data urls
    # @param [String] request_original_url original url of the request
    def initialize(statutory_instruments:, request_id: nil, data_alternates: nil, request_original_url: nil)
      @statutory_instruments = statutory_instruments
      @data_alternates = data_alternates
      @title = 'statutory-instruments.index.title'

      super(page_title: @title, request_id: request_id, data_alternates: data_alternates, request_original_url: request_original_url)
    end

    private

    def list_components
      @statutory_instruments.map do |statutory_instrument|
        ComponentSerializer::LinkComponentSerializer.new(link: "statutory-instruments/#{statutory_instrument.graph_id}", content: statutory_instrument.name).to_h
      end
    end
  end
end
