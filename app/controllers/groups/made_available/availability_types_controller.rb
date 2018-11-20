module Groups
  module MadeAvailable
    class AvailabilityTypesController < ApplicationController
      before_action :build_request, :data_check

      ROUTE_MAP = {
        index: proc { |params| ParliamentHelper.parliament_request.group_by_id.set_url_params({ group_id: params[:group_id] }) }
      }.freeze

      def index
        @group = FilterHelper.filter(@api_request, 'Group')
        @group = @group.first

        list_components = []

        if @group.is_a?(Parliament::Grom::Decorator::LayingBody)
          list_components << CardFactory.new(heading_text: 'groups.subsidiary-resources.layings', heading_translation_url: group_made_available_availability_types_laid_papers_path).build_card
        end

        heading = ComponentSerializer::Heading1ComponentSerializer.new(heading: I18n.t('groups.made_available.availability_types.title', group: @group.try(:groupName)), subheading: @group.try(:groupName), subheading_link: group_path)

        serializer = PageSerializer::ListPageSerializer.new(request: request, heading_component: heading, list_components: list_components, data_alternates: @alternates)

        render_page(serializer)
      end
    end
  end
end
