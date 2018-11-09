class GroupsController < ApplicationController
  # Controller rendering group index and show pages
  before_action :build_request, :data_check

  ROUTE_MAP = {
    index: proc { ParliamentHelper.parliament_request.group_index },
    show:  proc { |params| ParliamentHelper.parliament_request.group_by_id.set_url_params({ group_id: params[:group_id] }) }
  }.freeze

  def index
    @groups = FilterHelper.filter(@api_request, 'Group')
    @groups = @groups.sort_by(:groupName, :graph_id)

    list_components = [
      CardFactory.new(
        heading_text: 'laid-thing.laying-bodies',
        heading_url:  laying_bodies_path
      ).build_card
    ]

    heading = ComponentSerializer::Heading1ComponentSerializer.new(heading: I18n.t('groups.index.title'))

    serializer = PageSerializer::ListPageSerializer.new(request: request, heading_component: heading, list_components: list_components, data_alternates: @alternates)

    render_page(serializer)
  end

  def show
    @group = FilterHelper.filter(@api_request, 'Group')
    @group = @group.first

    serializer = PageSerializer::GroupsShowPageSerializer.new(request: request, group: @group, data_alternates: @alternates)

    render_page(serializer)
  end
end
