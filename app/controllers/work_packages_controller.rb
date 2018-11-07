class WorkPackagesController < ApplicationController
  # Controller rendering work-packages
  before_action :build_request, :data_check

  ROUTE_MAP = {
    current: proc { ParliamentHelper.parliament_request.work_package_current }
  }.freeze

  def current
    @work_packages = FilterHelper.filter(@api_request, 'WorkPackage')

    grouping_block = proc do |work_package|
      LayingDateHelper.get_date(work_package)
    end

    sorted_work_packages = GroupSortHelper.group_and_sort(@work_packages, group_block: grouping_block, key_sort_descending: true, sort_method_symbols: %i[work_packaged_thing workPackagedThingName])

    list_components = WorkPackageListComponentsFactory.build_components(work_packages: sorted_work_packages)

    heading = ComponentSerializer::Heading1ComponentSerializer.new(heading: I18n.t('work_packages.current.title'))

    serializer = PageSerializer::ListPageSerializer.new(request: request, heading_component: heading, list_components: list_components, data_alternates: @alternates)

    render_page(serializer)
  end
end
