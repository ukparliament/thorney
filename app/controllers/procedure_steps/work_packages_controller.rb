module ProcedureSteps
  class WorkPackagesController < ApplicationController
    before_action :build_request, :data_check

    ROUTE_MAP = {
      index:   proc { |params| ParliamentHelper.parliament_request.procedure_step_work_packages.set_url_params({ procedure_step_id: params[:procedure_step_id] }) },
      current: proc { |params| ParliamentHelper.parliament_request.procedure_step_work_packages_current.set_url_params({ procedure_step_id: params[:procedure_step_id] }) }
    }.freeze

    def index
      @procedure_step, @work_packages = FilterHelper.filter(@api_request, 'ProcedureStep', 'WorkPackage')
      @procedure_step = @procedure_step.first

      list_components = WorkPackageListComponentsFactory.sort_and_build_components(work_packages: @work_packages, date_type: :business_item_date)

      heading = ComponentSerializer::Heading1ComponentSerializer.new(heading: I18n.t('procedure_steps.work_packages.index.title', procedure_step: @procedure_step.try(:procedureStepName)), subheading: @procedure_step.try(:procedureStepName), subheading_link: procedure_step_path)

      serializer = PageSerializer::ListPageSerializer.new(request: request, heading_component: heading, list_components: list_components, data_alternates: @alternates)

      render_page(serializer)
    end

    def current
      @procedure_step, @work_packages = FilterHelper.filter(@api_request, 'ProcedureStep', 'WorkPackage')
      @procedure_step = @procedure_step.first

      list_components = WorkPackageListComponentsFactory.sort_and_build_components(work_packages: @work_packages, date_type: :business_item_date)

      heading = ComponentSerializer::Heading1ComponentSerializer.new(heading: I18n.t('procedure_steps.work_packages.current.title', procedure_step: @procedure_step.try(:procedureStepName)), subheading: @procedure_step.try(:procedureStepName), subheading_link: procedure_step_path)

      serializer = PageSerializer::ListPageSerializer.new(request: request, heading_component: heading, list_components: list_components, data_alternates: @alternates)

      render_page(serializer)
    end
  end
end
