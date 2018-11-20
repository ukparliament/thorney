module Groups
  module MadeAvailable
    module AvailabilityTypes
      class LaidPapersController < ApplicationController
        before_action :build_request, :data_check

        ROUTE_MAP = {
          index: proc { |params| ParliamentHelper.parliament_request.group_laid_papers_index.set_url_params({ group_id: params[:group_id] }) }
        }.freeze

        def index
          @group, @laid_papers = FilterHelper.filter(@api_request, 'Group', 'LaidThing')
          @group = @group.first

          list_components = LaidThingListComponentsFactory.sort_and_build_components(statutory_instruments: @laid_papers, type: :laid_thing, small: true)

          heading = ComponentSerializer::Heading1ComponentSerializer.new(heading: I18n.t('layings.title', group: @group.try(:groupName)), subheading: @group.try(:groupName), subheading_link: group_path)

          serializer = PageSerializer::ListPageSerializer.new(request: request, heading_component: heading, list_components: list_components, data_alternates: @alternates)

          render_page(serializer)
        end
      end
    end
  end
end
