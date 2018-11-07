module Groups
  module MadeAvailable
    module AvailabilityTypes
      class LayingsController < ApplicationController
        before_action :build_request, :data_check

        ROUTE_MAP = {
          index: proc { |params| ParliamentHelper.parliament_request.group_layings_index.set_url_params({ group_id: params[:group_id] }) }
        }.freeze

        def index
          @group, @layings = FilterHelper.filter(@api_request, 'Group', 'Laying')
          @layings = @layings.sort_by(:date, :graph_id).reverse
          @group = @group.first

          list_components = @layings.map do |laying|
            laying_type = I18n.t('layings.type.si')
            heading_text = laying.laid_thing.try(:laidThingName)
            heading_url = statutory_instrument_path(laying.laid_thing.graph_id)

            if laying.laid_thing.is_a?(Parliament::Grom::Decorator::ProposedNegativeStatutoryInstrumentPaper)
              laying_type = I18n.t('layings.type.pnsi')
              heading_url = proposed_negative_statutory_instrument_path(laying.laid_thing.graph_id)
            end

            list_description_items = [].tap do |items|
              items << { term: { content: 'laid-thing.laid-date' }, description: [{ content: I18n.l(laying&.date) }] }
            end

            CardFactory.new(
              small:                    laying_type,
              heading_text:             heading_text,
              heading_url:              heading_url,
              description_list_content: list_description_items
            ).build_card
          end

          heading = ComponentSerializer::Heading1ComponentSerializer.new(heading: I18n.t('layings.title'), subheading: @group.try(:groupName), subheading_link: group_path)

          serializer = PageSerializer::ListPageSerializer.new(request: request, heading_component: heading, list_components: list_components, data_alternates: @alternates)

          render_page(serializer)
        end
      end
    end
  end
end
