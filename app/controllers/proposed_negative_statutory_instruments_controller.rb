class ProposedNegativeStatutoryInstrumentsController < ApplicationController
  # Controller rendering proposed negative statutory instruments index and show pages
  before_action :build_request

  ROUTE_MAP = {
    index: proc { ParliamentHelper.parliament_request.proposed_negative_statutory_instrument_index },
    show:  proc { |params| ParliamentHelper.parliament_request.proposed_negative_statutory_instrument_by_id.set_url_params({ proposed_negative_statutory_instrument_id: params[:proposed_negative_statutory_instrument_id] }) }
  }.freeze

  def index
    @proposed_negative_statutory_instruments = FilterHelper.filter(@api_request, 'ProposedNegativeStatutoryInstrumentPaper')

    grouping_block = proc do |node|
      value = node.try(:laying).try(:date)

      next nil if value.nil?

      value.to_date
    end

    grouped_statutory_instruments = GroupSortHelper.group(@proposed_negative_statutory_instruments, block: grouping_block)

    statutory_instruments_sorted_by_keys = GroupSortHelper.sort_keys(grouped_statutory_instruments, descending: true)

    statutory_instruments_sorted = GroupSortHelper.sort(statutory_instruments_sorted_by_keys, method_symbols: [:proposedNegativeStatutoryInstrumentPaperName])

    list_components = LaidThingListComponentsFactory.build_components(statutory_instruments: statutory_instruments_sorted, type: :proposed_negative_statutory_instrument)

    heading = ComponentSerializer::Heading1ComponentSerializer.new(heading_content: I18n.t('proposed_negative_statutory_instruments.index.title'))

    serializer = PageSerializer::ListPageSerializer.new(request: request, heading_component: heading, list_components: list_components, data_alternates: @alternates)

    render_page(serializer)
  end

  def show
    @proposed_negative_statutory_instrument = FilterHelper.filter(@api_request, 'ProposedNegativeStatutoryInstrumentPaper')
    @proposed_negative_statutory_instrument = @proposed_negative_statutory_instrument.first

    serializer = PageSerializer::ProposedNegativeStatutoryInstrumentsShowPageSerializer.new(request: request, proposed_negative_statutory_instrument: @proposed_negative_statutory_instrument, data_alternates: @alternates)

    render_page(serializer)
  end
end
