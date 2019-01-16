class WorkPackagesController < ApplicationController
  # Controller rendering work-packages
  before_action :build_request, :data_check

  ROUTE_MAP = {
    current: proc { ParliamentHelper.parliament_request.work_package_current }
  }.freeze

  def current
    @work_packages = FilterHelper.filter(@api_request, 'WorkPackage')

    list_components = WorkPackageListComponentsFactory.sort_and_build_components(work_packages: @work_packages, date_type: :laying_date)

    heading = ComponentSerializer::Heading1ComponentSerializer.new(heading: I18n.t('work_packages.current.title'))

    serializer = PageSerializer::ListPageSerializer.new(request: request, heading_component: heading, list_components: list_components, data_alternates: @alternates)

    render_page(serializer)
  end
end
