module Groups
  module MadeAvailable
    module AvailabilityTypes
      module LaidPapers
        class PaperTypesController < ApplicationController
          # Controller rendering groups/made-available/availability-types/laid-papers/paper-types
          before_action :data_check, :build_request

          ROUTE_MAP = {
            index: proc { |params| ParliamentHelper.parliament_request.group_by_id.set_url_params({ group_id: params[:group_id] }) },
            show:  proc do |params|
              request = ParliamentHelper.parliament_request
              paper_type = params.fetch(:paper_type)

              request.group_laid_papers_paper_type_statutory_instruments.set_url_params({ group_id: params[:group_id] }) if paper_type == 'statutory-instruments'
              request.group_laid_papers_paper_type_proposed_negative_statutory_instruments.set_url_params({ group_id: params[:group_id] }) if paper_type == 'proposed-negative-statutory-instruments'

              request
            end
          }.freeze

          def index
            @group = FilterHelper.filter(@api_request, 'Group')
            @group = @group.first

            list_components = PaperTypesListComponentsFactory.build_components(group: @group)

            heading = ComponentSerializer::Heading1ComponentSerializer.new(heading: I18n.t('groups.made_available.availability_types.paper_types.index.title', group: @group.try(:groupName)), subheading: @group.try(:groupName), subheading_link: group_path)

            serializer = PageSerializer::ListPageSerializer.new(request: request, heading_component: heading, list_components: list_components, data_alternates: @alternates)

            render_page(serializer)
          end

          def show
            @group, @laid_things = FilterHelper.filter(@api_request, 'Group', 'LaidThing')
            @group = @group.first

            list_components = LaidThingListComponentsFactory.sort_and_build_components(statutory_instruments: @laid_things, type: :laid_thing)

            paper_type          = params.fetch(:paper_type)
            heading_translation = 'groups.made_available.availability_types.paper_types.show.si_title' if paper_type == 'statutory-instruments'
            heading_translation = 'groups.made_available.availability_types.paper_types.show.pnsi_title' if paper_type == 'proposed-negative-statutory-instruments'

            heading = ComponentSerializer::Heading1ComponentSerializer.new(heading: I18n.t(heading_translation, group: @group.try(:groupName)), subheading: @group.try(:groupName), subheading_link: group_path)

            serializer = PageSerializer::ListPageSerializer.new(request: request, heading_component: heading, list_components: list_components, data_alternates: @alternates)

            render_page(serializer)
          end
        end
      end
    end
  end
end
