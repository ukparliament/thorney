class LaidPapersController < ApplicationController
  # Controller rendering laid papers index and show pages
  before_action :build_request, :data_check

  ROUTE_MAP = {
    index: proc { ParliamentHelper.parliament_request.laid_paper_index },
    show:  proc { |params| ParliamentHelper.parliament_request.laid_paper_by_id.set_url_params({ laid_paper_id: params[:laid_paper_id] }) }
  }.freeze

  def index
    @laid_papers = FilterHelper.filter(@api_request, 'LaidThing')

    list_components = LaidThingListComponentsFactory.sort_and_build_components(statutory_instruments: @laid_papers, small: true)

    heading = ComponentSerializer::Heading1ComponentSerializer.new(heading: I18n.t('laid_papers.index.title'))

    serializer = PageSerializer::ListPageSerializer.new(request: request, heading_component: heading, list_components: list_components, data_alternates: @alternates)

    render_page(serializer)
  end

  def show
    @laying = FilterHelper.filter(@api_request, 'Laying')
    @laying = @laying.first

    serializer = PageSerializer::LayingsShowPageSerializer.new(request: request, laying: @laying, data_alternates: @alternates)

    render_page(serializer)
  end
end
