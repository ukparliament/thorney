class PaperTypesListComponentsFactory
  class << self
    include Rails.application.routes.url_helpers

    # Builds list components for paper types
    #
    # @param [Grom::Node] group Grom::Node of type Group
    #
    # @return [Array] array of Card components populated with the paper type data
    def build_components(group: nil)
      heading_links = if group
                        { pnsi_link: group_made_available_availability_types_laid_papers_paper_type_path(group_id: group.graph_id, paper_type: 'proposed-negative-statutory-instruments'), si_link: group_made_available_availability_types_laid_papers_paper_type_path(group_id: group.graph_id, paper_type: 'statutory-instruments') }
                      else
                        { pnsi_link: work_packages_paper_type_path('proposed-negative-statutory-instruments'), si_link: work_packages_paper_type_path('statutory-instruments') }
                      end

      [
        CardFactory.new(
          heading_text: I18n.t('proposed_negative_statutory_instruments.type').pluralize,
          heading_url:  heading_links[:pnsi_link]
        ).build_card,
        CardFactory.new(
          heading_text: I18n.t('statutory_instruments.type').pluralize,
          heading_url:  heading_links[:si_link]
        ).build_card
      ]
    end
  end
end
