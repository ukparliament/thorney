class StatutoryInstrumentsController < ApplicationController
  # Controller rendering statutory instruments index and show pages
  before_action :build_request, :data_check

  ROUTE_MAP = {
    index: proc { ParliamentHelper.parliament_request.statutory_instrument_index },
    show:  proc { |params| ParliamentHelper.parliament_request.statutory_instrument_by_id.set_url_params({ statutory_instrument_id: params[:statutory_instrument_id] }) }
  }.freeze

  def index
    @statutory_instruments = FilterHelper.filter(@api_request, 'StatutoryInstrumentPaper')

    grouping_block = proc do |node|
      value = node.try(:laying).try(:date)

      next nil if value.nil?

      value.to_date
    end

    grouped_statutory_instruments = GroupSortHelper.group(@statutory_instruments, block: grouping_block)

    statutory_instruments_sorted_by_keys = GroupSortHelper.sort_keys(grouped_statutory_instruments, descending: true)

    statutory_instruments_sorted = GroupSortHelper.sort(statutory_instruments_sorted_by_keys, method_symbols: [:statutoryInstrumentPaperName])

    list_components = LaidThingListComponentsFactory.build_components(statutory_instruments: statutory_instruments_sorted, type: :statutory_instrument)

    heading = ComponentSerializer::Heading1ComponentSerializer.new(heading_content: I18n.t('statutory_instruments.index.title'))

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
