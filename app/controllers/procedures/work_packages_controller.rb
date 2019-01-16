module Procedures
  class WorkPackagesController < ApplicationController
    # Controller rendering procedures/:procedure/work-packages
    before_action :data_check, :build_request

    ROUTE_MAP = {
      index:   proc { |params| ParliamentHelper.parliament_request.procedure_work_packages.set_url_params({ procedure_id: params[:procedure_id] }) },
      current: proc { |params| ParliamentHelper.parliament_request.procedure_work_packages_current.set_url_params({ procedure_id: params[:procedure_id] }) }
    }.freeze

    def index
      @procedure, @work_packages = FilterHelper.filter(@api_request, 'Procedure', 'WorkPackage')

      @procedure = @procedure.first

      list_components = WorkPackageListComponentsFactory.sort_and_build_components(work_packages: @work_packages, date_type: :laying_date)

      heading = ComponentSerializer::Heading1ComponentSerializer.new(heading: I18n.t('procedures.work_packages.index.title', procedure: @procedure.try(:procedureName)), subheading: @procedure.try(:procedureName), subheading_link: procedure_path)

      serializer = PageSerializer::ListPageSerializer.new(request: request, heading_component: heading, list_components: list_components, data_alternates: @alternates)

      render_page(serializer)
    end

    def current
      @procedure, @work_packages = FilterHelper.filter(@api_request, 'Procedure', 'WorkPackage')

      @procedure = @procedure.first

      list_components = WorkPackageListComponentsFactory.sort_and_build_components(work_packages: @work_packages, date_type: :laying_date)

      heading = ComponentSerializer::Heading1ComponentSerializer.new(heading: I18n.t('procedures.work_packages.current.title', procedure: @procedure.try(:procedureName)), subheading: @procedure.try(:procedureName), subheading_link: procedure_path)

      serializer = PageSerializer::ListPageSerializer.new(request: request, heading_component: heading, list_components: list_components, data_alternates: @alternates)

      render_page(serializer)
    end
  end
end
