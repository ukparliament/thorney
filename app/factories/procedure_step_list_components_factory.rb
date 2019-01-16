class ProcedureStepListComponentsFactory
  class << self
    include Rails.application.routes.url_helpers
    include ListDescriptionHelper

    # Builds list components for procedure steps
    #
    # @param [Array] procedure_steps list of procedure steps
    #
    # @return [Array] array of Card components populated with the procedure step data
    def build_components(procedure_steps: nil)
      procedure_steps.map do |procedure_step|
        houses_description = procedure_step.try(:procedureStepHasHouse) ? houses_description_list(procedure_step) : nil

        paragraph_content = [{ content: procedure_step.try(:procedureStepDescription) }] if procedure_step.try(:procedureStepDescription)

        CardFactory.new(
          heading_text:             procedure_step.try(:procedureStepName),
          heading_url:              procedure_step_path(procedure_step.graph_id),
          description_list_content: houses_description,
          paragraph_content:        paragraph_content
        ).build_card
      end
    end

    private

    def houses_description_list(procedure_step)
      houses_string = procedure_step.try(:procedureStepHasHouse).map { |house| house.try(:houseName) }.compact.sort.to_sentence

      create_description_list_item(term: 'procedure-steps.houses', descriptions: [houses_string]) if houses_string
    end
  end
end
