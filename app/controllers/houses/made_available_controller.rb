module Houses
  class MadeAvailableController < ApplicationController
    before_action :build_request, :data_check

    ROUTE_MAP = {
      index: proc { |params| ParliamentHelper.parliament_request.house_laid_papers.set_url_params({ house_id: params[:house_id] }) }
    }.freeze

    def index
      @house, @laid_papers = FilterHelper.filter(@api_request, 'House', 'Laying')


      heading = ComponentSerializer::Heading1ComponentSerializer.new(heading: I18n.t('groups.made_available.title', group: @group.try(:groupName)), subheading: @group.try(:groupName), subheading_link: group_path)

      serializer = PageSerializer::ListPageSerializer.new(request: request, heading_component: heading, list_components: list_components, data_alternates: @alternates)

      render_page(serializer)
    end
  end
end
