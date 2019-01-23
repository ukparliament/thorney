module Treaties
  class WorkPackagesController < ApplicationController
    before_action :build_request, :data_check

    ROUTE_MAP = {
      index: proc { |params| ParliamentHelper.parliament_request.treaty_work_packages.set_url_params({ treaty_id: params[:treaty_id] }) }
    }.freeze

    def index
      @work_packaged_thing, @work_packages = FilterHelper.filter(@api_request, 'WorkPackagedThing', 'WorkPackage')
      @work_packaged_thing = @work_packaged_thing.first

      list_components = WorkPackageListComponentsFactory.sort_and_build_components(work_packages: @work_packages, date_type: :laying_date)

      heading = ComponentSerializer::Heading1ComponentSerializer.new(heading: I18n.t('treaties.work_packages.index.title', treaty: @work_packaged_thing.try(:workPackagedThingName)), subheading: @work_packaged_thing.try(:workPackagedThingName), subheading_link: treaty_path)

      serializer = PageSerializer::ListPageSerializer.new(request: request, heading_component: heading, list_components: list_components, data_alternates: @alternates)

      render_page(serializer)
    end
  end
end
