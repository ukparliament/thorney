module PageSerializer
  class ProposedNegativeStatutoryInstrumentsIndexPageSerializer < ListPageSerializer
    # Initialise a Proposed Negative Statutory Instruments index page serializer.
    #
    # @param [Array<Grom::Node>] proposed_negative_statutory_instruments an array of Grom::Node objects of type ProposedNegativeStatutoryInstrumentPaper.
    # @param [String] request_id AppInsights request id
    # @param [Array<Hash>] data_alternates array containing the href and type of the alternative data urls
    # @param [String] request_original_url original url of the request
    def initialize(proposed_negative_statutory_instruments:, request_id: nil, data_alternates: nil, request_original_url: nil)
      @proposed_negative_statutory_instruments = proposed_negative_statutory_instruments
      @data_alternates = data_alternates
      @title = 'proposed-negative-statutory-instruments.index.title'

      super(page_title: @title, request_id: request_id, data_alternates: data_alternates, request_original_url: request_original_url)
    end

    private

    def list_components
      @proposed_negative_statutory_instruments.map do |statutory_instrument|
        ComponentSerializer::LinkComponentSerializer.new(link: statutory_instruments_path(statutory_instrument.graph_id), content: statutory_instrument.name).to_h
      end
    end
  end
end
