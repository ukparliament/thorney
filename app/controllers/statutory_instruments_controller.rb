class StatutoryInstrumentsController < ApplicationController
  before_action :build_request

  ROUTE_MAP = {
    index: proc { Parliament::Utils::Helpers::ParliamentHelper.parliament_request.statutory_instrument_index },
    show:  proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.statutory_instrument_by_id.set_url_params({ statutory_instrument_id: params[:statutory_instrument_id] }) }
  }.freeze

  def index
    @statutory_instruments = Parliament::Utils::Helpers::FilterHelper.filter(@request, 'StatutoryInstrumentPaper')

    render_page(PageSerializer::StatutoryInstrumentsIndexPageSerializer.new(statutory_instruments: @statutory_instruments, request_id: app_insights_request_id))
  end

  def show
    @statutory_instrument = Parliament::Utils::Helpers::FilterHelper.filter(@request, 'StatutoryInstrumentPaper')
    @statutory_instrument = @statutory_instrument.first

    render_page(PageSerializer::StatutoryInstrumentsShowPageSerializer.new(statutory_instrument: @statutory_instrument, request_id: app_insights_request_id))
  end
end
