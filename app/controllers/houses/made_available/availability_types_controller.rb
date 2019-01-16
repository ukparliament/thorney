module Houses
  module MadeAvailable
    class AvailabilityTypesController < ApplicationController
      before_action :build_request, :data_check

      ROUTE_MAP = {
        index: proc { |params| ParliamentHelper.parliament_request.house_by_id.set_url_params({ house_id: params[:house_id] }) }
      }.freeze

      def index
        @house = FilterHelper.filter(@api_request, 'House')
        @house = @house.first

        list_components = [CardFactory.new(heading_text: 'houses.subsidiary-resources.laid-papers', heading_translation_url: house_made_available_availability_types_laid_papers_path).build_card]

        heading = ComponentSerializer::Heading1ComponentSerializer.new(heading: I18n.t('houses.made_available.availability_types.title', house: @house.try(:houseName)), subheading: @house.try(:houseName), subheading_link: house_path)

        serializer = PageSerializer::ListPageSerializer.new(request: request, heading_component: heading, list_components: list_components, data_alternates: @alternates)

        render_page(serializer)
      end
    end
  end
end
