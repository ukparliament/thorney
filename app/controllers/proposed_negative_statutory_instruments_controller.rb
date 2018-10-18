class ProposedNegativeStatutoryInstrumentsController < ApplicationController
  # Controller rendering proposed negative statutory instruments index and show pages
  before_action :build_request

  ROUTE_MAP = {
    index: proc { ParliamentHelper.parliament_request.proposed_negative_statutory_instrument_index },
    show:  proc { |params| ParliamentHelper.parliament_request.proposed_negative_statutory_instrument_by_id.set_url_params({ proposed_negative_statutory_instrument_id: params[:proposed_negative_statutory_instrument_id] }) }
  }.freeze

  def index
    @proposed_negative_statutory_instruments = FilterHelper.filter(@api_request, 'ProposedNegativeStatutoryInstrumentPaper')

    list_components = LaidThingListComponentsFactory.new(statutory_instruments: @proposed_negative_statutory_instruments, type: :proposed_negative_statutory_instrument).build_components

    serializer = PageSerializer::ListPageSerializer.new(request: request, page_title: I18n.t('proposed_negative_statutory_instruments.index.title'), list_components: list_components, data_alternates: @alternates)

    render_page(serializer)
  end

  def show
    @proposed_negative_statutory_instrument = FilterHelper.filter(@api_request, 'ProposedNegativeStatutoryInstrumentPaper')
    @proposed_negative_statutory_instrument = @proposed_negative_statutory_instrument.first

    serializer = PageSerializer::ProposedNegativeStatutoryInstrumentsShowPageSerializer.new(request: request, proposed_negative_statutory_instrument: @proposed_negative_statutory_instrument, data_alternates: @alternates)

    render_page(serializer)
  end
end
