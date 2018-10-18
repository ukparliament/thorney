module Groups
  class LayingsController < ApplicationController
    before_action :build_request, :data_check

    ROUTE_MAP = {
      index: proc { |params| ParliamentHelper.parliament_request.group_layings_index.set_url_params({ group_id: params[:group_id] }) }
    }.freeze

    def index
      @group, @layings = FilterHelper.filter(@api_request, 'Group', 'Laying')
      @group = @group.first

      list_components = @layings.map do |laying|
        laying_type = I18n.t('layings.type.si')
        heading_url = statutory_instrument_path(laying.laid_thing.graph_id)

        if laying.laid_thing.is_a?(Parliament::Grom::Decorator::ProposedNegativeStatutoryInstrumentPaper)
          laying_type = I18n.t('layings.type.pnsi')
          heading_url = proposed_negative_statutory_instrument_path(laying.laid_thing.graph_id)
        end

        paragraph_content = [].tap do |content|
          content << { content: 'groups.layings.date', date: I18n.l(Time.parse(laying.date.to_s)) } if laying.date
          content << { content: 'groups.layings.type', type: laying_type } if laying.type
        end

        CardFactory.new(
          heading_text:      laying.laid_thing.try(:laidThingName),
          heading_url:       heading_url,
          paragraph_content: paragraph_content
        ).build_card
      end

      heading = ComponentSerializer::Heading1ComponentSerializer.new(heading_content: I18n.t('layings.title'), subheading_content: @group.try(:groupName), subheading_link: group_path)

      serializer = PageSerializer::ListPageSerializer.new(request: request, heading_component: heading, list_components: list_components, data_alternates: @alternates)

      render_page(serializer)
    end
  end
end
