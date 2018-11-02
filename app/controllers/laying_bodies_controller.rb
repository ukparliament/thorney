class LayingBodiesController < ApplicationController
  # Controller rendering laying bodies index page
  before_action :build_request, :data_check

  ROUTE_MAP = {
    index: proc {ParliamentHelper.parliament_request.laying_body_index},
  }.freeze

  def index
    @groups = FilterHelper.filter(@api_request, 'LayingBody')
    @groups = @groups.sort_by(:groupName, :graph_id)

    list_components = @groups.map do |group|
      CardFactory.new(
        heading_text: group.try(:groupName),
        heading_url:  group_path(group.graph_id)
      ).build_card
    end

    heading = ComponentSerializer::Heading1ComponentSerializer.new(heading_content: I18n.t('laying_bodies.index.title'))

    serializer = PageSerializer::ListPageSerializer.new(request: request, heading_component: heading, list_components: list_components, data_alternates: @alternates)

    render_page(serializer)
  end
end