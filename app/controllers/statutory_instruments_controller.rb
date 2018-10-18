class StatutoryInstrumentsController < ApplicationController
  # Controller rendering statutory instruments index and show pages
  before_action :build_request, :data_check

  ROUTE_MAP = {
    index: proc {ParliamentHelper.parliament_request.statutory_instrument_index},
    show:  proc {|params| ParliamentHelper.parliament_request.statutory_instrument_by_id.set_url_params({ statutory_instrument_id: params[:statutory_instrument_id] })}
  }.freeze

  def index
    @statutory_instruments = FilterHelper.filter(@api_request, 'StatutoryInstrumentPaper')

    list_components = LaidThingListComponentsFactory.new(statutory_instruments: @statutory_instruments, type: :statutory_instrument).build_components

    serializer = PageSerializer::ListPageSerializer.new(request: request, page_title: I18n.t('statutory_instruments.index.title'), list_components: list_components, data_alternates: @alternates)

    render_page(serializer)
  end

  def show
    @statutory_instrument = FilterHelper.filter(@api_request, 'StatutoryInstrumentPaper')
    @statutory_instrument = @statutory_instrument.first

    serializer = PageSerializer::StatutoryInstrumentsShowPageSerializer.new(request: request, statutory_instrument: @statutory_instrument, data_alternates: @alternates)

    render_page(serializer)
  end
end
