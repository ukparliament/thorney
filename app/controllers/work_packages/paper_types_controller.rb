module WorkPackages
  class PaperTypesController < ApplicationController
    # Controller rendering work-packages/paper-types
    before_action :data_check, :build_request, except: %i[index]

    ROUTE_MAP = {
      show:    proc do |params|
        request = ParliamentHelper.parliament_request
        paper_type = params.fetch(:paper_type)

        request.work_packages_paper_types_statutory_instruments if paper_type == 'statutory-instruments'
        request.work_packages_paper_types_proposed_negative_statutory_instruments if paper_type == 'proposed-negative-statutory-instruments'

        request
      end,
      current: proc do |params|
        request = ParliamentHelper.parliament_request
        paper_type = params.fetch(:paper_type)

        request.work_packages_paper_types_statutory_instruments_current if paper_type == 'statutory-instruments'
        request.work_packages_paper_types_proposed_negative_statutory_instruments_current if paper_type == 'proposed-negative-statutory-instruments'

        request
      end
    }.freeze

    def index
      list_components = [
        CardFactory.new(
          heading_text: 'Proposed Negative Statutory Instruments',
          heading_url:  work_packages_paper_type_path('proposed-negative-statutory-instruments')
        ).build_card,
        CardFactory.new(
          heading_text: 'Statutory Instruments',
          heading_url:  work_packages_paper_type_path('statutory-instruments')
        ).build_card
      ]

      heading = ComponentSerializer::Heading1ComponentSerializer.new(heading: I18n.t('work_packages.paper_types.index.title'))

      serializer = PageSerializer::ListPageSerializer.new(request: request, heading_component: heading, list_components: list_components)

      render_page(serializer)
    end

    def show
      @work_packages = FilterHelper.filter(@api_request, 'WorkPackage')

      list_components = WorkPackageListComponentsFactory.sort_and_build_components(work_packages: @work_packages, group_by: :laying_date)

      paper_type = params.fetch(:paper_type)
      heading_translation = 'work_packages.paper_types.show.si_title' if paper_type == 'statutory-instruments'
      heading_translation = 'work_packages.paper_types.show.psni_title' if paper_type == 'proposed-negative-statutory-instruments'

      heading = ComponentSerializer::Heading1ComponentSerializer.new(heading: I18n.t(heading_translation))

      serializer = PageSerializer::ListPageSerializer.new(request: request, heading_component: heading, list_components: list_components, data_alternates: @alternates)

      render_page(serializer)
    end

    def current
      @work_packages = FilterHelper.filter(@api_request, 'WorkPackage')

      list_components = WorkPackageListComponentsFactory.sort_and_build_components(work_packages: @work_packages, group_by: :laying_date)

      paper_type = params.fetch(:paper_type)
      heading_translation = 'work_packages.paper_types.current.si_title' if paper_type == 'statutory-instruments'
      heading_translation = 'work_packages.paper_types.current.psni_title' if paper_type == 'proposed-negative-statutory-instruments'

      heading = ComponentSerializer::Heading1ComponentSerializer.new(heading: I18n.t(heading_translation))

      serializer = PageSerializer::ListPageSerializer.new(request: request, heading_component: heading, list_components: list_components, data_alternates: @alternates)

      render_page(serializer)
    end
  end
end
