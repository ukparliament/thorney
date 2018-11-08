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

      grouping_block = proc do |work_package|
        LayingDateHelper.get_date(work_package)
      end

      sorted_work_packages = GroupSortHelper.group_and_sort(@work_packages, group_block: grouping_block, key_sort_descending: true, sort_method_symbols: %i[work_packaged_thing workPackagedThingName])

      list_components = WorkPackageListComponentsFactory.build_components(work_packages: sorted_work_packages)

      heading = ComponentSerializer::Heading1ComponentSerializer.new(heading: I18n.t('work_packages.index.title'), subheading: @procedure.try(:procedureName), subheading_link: procedure_path)

      serializer = PageSerializer::ListPageSerializer.new(request: request, heading_component: heading, list_components: list_components, data_alternates: @alternates)

      render_page(serializer)
    end

    def current
      @procedure, @work_packages = FilterHelper.filter(@api_request, 'Procedure', 'WorkPackage')

      @procedure = @procedure.first

      grouping_block = proc do |work_package|
        LayingDateHelper.get_date(work_package)
      end

      sorted_work_packages = GroupSortHelper.group_and_sort(@work_packages, group_block: grouping_block, key_sort_descending: true, sort_method_symbols: %i[work_packaged_thing workPackagedThingName])

      list_components = WorkPackageListComponentsFactory.build_components(work_packages: sorted_work_packages)

      heading = ComponentSerializer::Heading1ComponentSerializer.new(heading: I18n.t('work_packages.current.title'), subheading: @procedure.try(:procedureName), subheading_link: procedure_path)

      serializer = PageSerializer::ListPageSerializer.new(request: request, heading_component: heading, list_components: list_components, data_alternates: @alternates)

      render_page(serializer)
    end
  end
end
