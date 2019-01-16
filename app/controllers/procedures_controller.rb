class ProceduresController < ApplicationController
  # Controller rendering procedures index and show pages
  before_action :build_request, :data_check

  ROUTE_MAP = {
    index: proc { ParliamentHelper.parliament_request.procedure_index },
    show:  proc { |params| ParliamentHelper.parliament_request.procedure_by_id.set_url_params({ procedure_id: params[:procedure_id] }) }
  }.freeze

  def index
    @procedures = FilterHelper.filter(@api_request, 'Procedure')
    @procedures = @procedures.sort_by(:procedureName)

    list_components = @procedures.map do |procedure|
      CardFactory.new(heading_text: procedure.try(:procedureName),
                      heading_url:  procedure_path(procedure.graph_id)).build_card
    end

    heading = ComponentSerializer::Heading1ComponentSerializer.new(heading: I18n.t('procedures.index.title'))

    serializer = PageSerializer::ListPageSerializer.new(request: request, heading_component: heading, list_components: list_components, data_alternates: @alternates)

    render_page(serializer)
  end

  def show
    @procedure = FilterHelper.filter(@api_request, 'Procedure')
    @procedure = @procedure.first

    serializer = PageSerializer::ProceduresShowPageSerializer.new(request: request, procedure: @procedure, data_alternates: @alternates)

    render_page(serializer)
  end
end
