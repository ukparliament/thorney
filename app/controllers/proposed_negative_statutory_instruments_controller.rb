class ProposedNegativeStatutoryInstrumentsController < ApplicationController
  # Controller rendering proposed negative statutory instruments index and show pages
  before_action :build_request

  ROUTE_MAP = {
    index: proc { ParliamentHelper.parliament_request.proposed_negative_statutory_instrument_index },
    show:  proc { |params| ParliamentHelper.parliament_request.proposed_negative_statutory_instrument_by_id.set_url_params({ proposed_negative_statutory_instrument_id: params[:proposed_negative_statutory_instrument_id] }) }
  }.freeze

  def index
    @proposed_negative_statutory_instruments = FilterHelper.filter(@request, 'ProposedNegativeStatutoryInstrumentPaper')
    serializer = PageSerializer::ProposedNegativeStatutoryInstrumentsIndexPageSerializer.new(proposed_negative_statutory_instruments: @proposed_negative_statutory_instruments, request_id: app_insights_request_id, data_alternates: @alternates, request_original_url: request.original_url)

    render_page(serializer)
  end

  def show
    @proposed_negative_statutory_instrument = FilterHelper.filter(@request, 'ProposedNegativeStatutoryInstrumentPaper')
    @proposed_negative_statutory_instrument = @proposed_negative_statutory_instrument.first

    serializer = PageSerializer::ProposedNegativeStatutoryInstrumentsShowPageSerializer.new(proposed_negative_statutory_instrument: @proposed_negative_statutory_instrument, request_id: app_insights_request_id, data_alternates: @alternates, request_original_url: request.original_url)

    render_page(serializer)
  end
end
