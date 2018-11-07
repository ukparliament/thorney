class StatutoryInstrumentsController < ApplicationController
  # Controller rendering statutory instruments index and show pages
  before_action :build_request, :data_check

  ROUTE_MAP = {
    index: proc { ParliamentHelper.parliament_request.statutory_instrument_index },
    show:  proc { |params| ParliamentHelper.parliament_request.statutory_instrument_by_id.set_url_params({ statutory_instrument_id: params[:statutory_instrument_id] }) }
  }.freeze

  def index
    @statutory_instruments = FilterHelper.filter(@api_request, 'StatutoryInstrumentPaper')

    sorted_statutory_instruments = GroupSortHelper.group_and_sort(@statutory_instruments, group_method_symbols: %i[laying date to_date], key_sort_descending: true, sort_method_symbols: [:statutoryInstrumentPaperName])

    list_components = LaidThingListComponentsFactory.build_components(statutory_instruments: sorted_statutory_instruments, type: :statutory_instrument)

    heading = ComponentSerializer::Heading1ComponentSerializer.new(heading: I18n.t('statutory_instruments.index.title'))

    serializer = PageSerializer::ListPageSerializer.new(request: request, heading_component: heading, list_components: list_components, data_alternates: @alternates)

    render_page(serializer)
  end

  def show
    @statutory_instrument = FilterHelper.filter(@api_request, 'StatutoryInstrumentPaper')
    @statutory_instrument = @statutory_instrument.first

    serializer = PageSerializer::StatutoryInstrumentsShowPageSerializer.new(request: request, statutory_instrument: @statutory_instrument, data_alternates: @alternates)

    render_page(serializer)
  end
end
