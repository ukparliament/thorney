module ProcedureSteps
  class WorkPackagesController < ApplicationController
    before_action :build_request, :data_check

    ROUTE_MAP = {
      index: proc { |params| ParliamentHelper.parliament_request.procedure_step_work_packages.set_url_params({ procedure_step_id: params[:procedure_step_id] }) }
    }.freeze

    def index
      @procedure_step, @business_items = FilterHelper.filter(@api_request, 'ProcedureStep', 'BusinessItem')
      @procedure_step = @procedure_step.first

      @business_items = @business_items.sort_by(:date, :graph_id).reverse

      list_components = @business_items.map do |business_item|
        next nil unless business_item.work_package

        list_description_items = nil
        if business_item.date
          list_description_items = [{ term: { content: 'procedure-steps.subsidiary-resources.actualised-date' }, description: [{ content: I18n.l(business_item.date) }] }]
        end

        CardFactory.new(
          small:                    'laid-thing.work-package',
          heading_text:             business_item.work_package.work_packaged_thing.try(:workPackagedThingName),
          heading_url:              work_package_path(business_item.work_package.graph_id),
          description_list_content: list_description_items
        ).build_card
      end
      list_components.compact!

      heading = ComponentSerializer::Heading1ComponentSerializer.new(heading_content: I18n.t('work_packages.title'), subheading_content: @procedure_step.try(:procedureStepName), subheading_link: procedure_step_path)

      serializer = PageSerializer::ListPageSerializer.new(request: request, heading_component: heading, list_components: list_components, data_alternates: @alternates)

      render_page(serializer)
      end
  end
end
