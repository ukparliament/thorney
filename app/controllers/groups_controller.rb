class GroupsController < ApplicationController
  # Controller rendering group index and show pages
  before_action :build_request, :data_check

  ROUTE_MAP = {
    index: proc { ParliamentHelper.parliament_request.group_index },
    show:  proc { |params| ParliamentHelper.parliament_request.group_by_id.set_url_params({ group_id: params[:group_id] }) }
  }.freeze

  def index
    @groups = FilterHelper.filter(@api_request, 'Group')

    list_components = @groups.map do |group|
      paragraph_content = [].tap do |content|
        content << { content: I18n.t('prepositional_to', first: I18n.l(Time.parse(group.groupStartDate)), second: I18n.l(Time.parse(group.groupEndDate))) } if group.try(:groupStartDate) && group.try(:groupEndDate)
        content << { content: I18n.l(Time.parse(group.groupStartDate)) } if group.try(:groupStartDate) && !group.try(:groupEndDate)
      end

      CardFactory.new(
        heading_text:      group.try(:groupName),
        heading_url:       group_path(group.graph_id),
        paragraph_content: paragraph_content
      ).build_card
    end

    serializer = PageSerializer::ListPageSerializer.new(request: request, page_title: I18n.t('groups.index.title'), list_components: list_components, data_alternates: @alternates)

    render_page(serializer)
  end

  def show
    @group = FilterHelper.filter(@api_request, 'Group')
    @group = @group.first

    serializer = PageSerializer::GroupsShowPageSerializer.new(request: request, group: @group, data_alternates: @alternates)

    render_page(serializer)
  end
end
