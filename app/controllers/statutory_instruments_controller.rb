class StatutoryInstrumentsController < ApplicationController
  # Controller rendering statutory instruments index and show pages
  before_action :build_request, :data_check

  ROUTE_MAP = {
    index: proc { ParliamentHelper.parliament_request.statutory_instrument_index },
    show:  proc { |params| ParliamentHelper.parliament_request.statutory_instrument_by_id.set_url_params({ statutory_instrument_id: params[:statutory_instrument_id] }) }
  }.freeze

  def index
    @statutory_instruments = FilterHelper.filter(@request, 'StatutoryInstrumentPaper')

    list_components = @statutory_instruments.map do |statutory_instrument|
      CardFactory.new(
        heading_text: statutory_instrument.name,
        heading_url:  statutory_instrument_path(statutory_instrument.graph_id)
      ).build_card
    end

    serializer = PageSerializer::ListPageSerializer.new(page_title: 'statutory-instruments.index.title', list_components: list_components, request_id: app_insights_request_id, data_alternates: @alternates, request_original_url: request.original_url)

    render_page(serializer)
  end

  def show
    @statutory_instrument = FilterHelper.filter(@request, 'StatutoryInstrumentPaper')
    @statutory_instrument = @statutory_instrument.first

    serializer = PageSerializer::StatutoryInstrumentsShowPageSerializer.new(statutory_instrument: @statutory_instrument, request_id: app_insights_request_id, data_alternates: @alternates, request_original_url: request.original_url)

    render_page(serializer)
  end
end
