class TreatiesController < ApplicationController
  # Controller rendering treaties index and show pages
  before_action :build_request

  ROUTE_MAP = {
    index:  proc { ParliamentHelper.parliament_request.treaty_index },
    show:   proc { |params| ParliamentHelper.parliament_request.treaty_by_id.set_url_params({ treaty_id: params[:treaty_id] }) },
    lookup: proc { |params| ParliamentHelper.parliament_request.treaty_lookup.set_url_params({ property: params[:source], value: params[:id] }) }
  }.freeze

  def index
    @treaties = FilterHelper.filter(@api_request, 'Treaty')
    list_components = LaidThingListComponentsFactory.sort_and_build_components(statutory_instruments: @treaties)

    heading = ComponentSerializer::Heading1ComponentSerializer.new(heading: I18n.t('treaties.index.title'))

    serializer = PageSerializer::ListPageSerializer.new(request: request, heading_component: heading, list_components: list_components, data_alternates: @alternates)

    render_page(serializer)
  end

  def show
    @treaty = FilterHelper.filter(@api_request, 'Treaty')
    @treaty = @treaty.first

    serializer = PageSerializer::TreatiesShowPageSerializer.new(request: request, treaty: @treaty, data_alternates: @alternates)

    render_page(serializer)
  end

  def lookup
    @treaty = FilterHelper.filter(@api_request, 'Treaty')
    @treaty = @treaty.first

    redirect_to :action => 'show', 'treaty_id' => @treaty.graph_id
  end
end
