class ProcedureStepsController < ApplicationController
  before_action :build_request, :data_check

  ROUTE_MAP = {
    index: proc { ParliamentHelper.parliament_request.procedure_step_index },
    show:  proc { |params| ParliamentHelper.parliament_request.procedure_step_by_id.set_url_params({ procedure_step_id: params[:procedure_step_id] }) }
  }.freeze

  def index
    @procedure_steps = FilterHelper.filter(@api_request, 'ProcedureStep')
    @procedure_steps = @procedure_steps.sort_by(:procedureStepName, :graph_id)

    list_components = ProcedureStepListComponentsFactory.build_components(procedure_steps: @procedure_steps)

    heading = ComponentSerializer::Heading1ComponentSerializer.new(heading: I18n.t('procedure_steps.index.title'))

    serializer = PageSerializer::ListPageSerializer.new(request: request, heading_component: heading, list_components: list_components, data_alternates: @alternates)

    render_page(serializer)
  end

  def show
    @procedure_step = FilterHelper.filter(@api_request, 'ProcedureStep')
    @procedure_step = @procedure_step.first

    serializer = PageSerializer::ProcedureStepsShowPageSerializer.new(request: request, procedure_step: @procedure_step, data_alternates: @alternates)

    render_page(serializer)
  end
end
