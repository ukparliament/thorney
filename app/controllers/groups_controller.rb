class GroupsController < ApplicationController
  # Controller rendering group index and show pages
  before_action :build_request, :data_check

  ROUTE_MAP = {
    index:   proc { ParliamentHelper.parliament_request.group_index },
    current: proc { ParliamentHelper.parliament_request.group_current },
    show:    proc { |params| ParliamentHelper.parliament_request.group_by_id.set_url_params({ group_id: params[:group_id] }) }
  }.freeze

  def index
    @groups = FilterHelper.filter(@request, 'Group')

    list_components = @groups.map do |group|
      paragraph_content = [].tap do |content|
        content << { content: "#{I18n.l(DateTime.parse(group.groupStartDate))} to #{I18n.l(DateTime.parse(group.groupEndDate))}" } if group.try(:groupStartDate) && group.try(:groupEndDate)
        content << { content: I18n.l(DateTime.parse(group.groupStartDate)) } if group.try(:groupStartDate) && !group.try(:groupEndDate)
      end
      CardFactory.new(
        heading_text:      group.try(:groupName),
        heading_url:       group_path(group.graph_id),
        paragraph_content: paragraph_content
      ).build_card
    end

    serializer = PageSerializer::ListPageSerializer.new(page_title: 'groups.index.title', list_components: list_components, request_id: app_insights_request_id, data_alternates: @alternates, request_original_url: request.original_url)

    render_page(serializer)
  end

  def show
    @group = FilterHelper.filter(@request, 'Group')
    @group = @group.first

    serializer = PageSerializer::GroupsShowPageSerializer.new(group: @group, request_id: app_insights_request_id, data_alternates: @alternates, request_original_url: request.original_url)

    render_page(serializer)
  end
end
