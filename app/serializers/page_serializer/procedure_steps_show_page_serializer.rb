module PageSerializer
  class ProcedureStepsShowPageSerializer < PageSerializer::BasePageSerializer
    # Initialise a Procedure Steps show page serializer.
    #
    # @param [ActionDispatch::Request] request the current request object.
    # @param [<Grom::Node>] procedure_step a Grom::Node object of type ProcedureStep.
    # @param [Array<Hash>] data_alternates array containing the href and type of the alternative data urls.
    def initialize(request: nil, procedure_step: nil, data_alternates: nil)
      @procedure_step = procedure_step
      super(request: request, data_alternates: data_alternates)
    end

    private

    def meta
      super(title: title)
    end

    def title
      @procedure_step.try(:procedureStepName) || t('no_name')
    end

    def content
      [].tap do |components|
        components << ComponentSerializer::SectionComponentSerializer.new(components: section_primary_components, type: 'primary', content_flag: true).to_h
        components << ComponentSerializer::SectionComponentSerializer.new(components: section_components, type: 'section').to_h
      end
    end

    def section_primary_components
      [].tap do |components|
        components << ComponentSerializer::Heading1ComponentSerializer.new(heading_content).to_h
        components << ComponentSerializer::ListDescriptionComponentSerializer.new(items: meta_info, meta: true).to_h unless meta_info.nil?
      end
    end

    def meta_info
      houses = @procedure_step.try(:procedureStepHasHouse)
      return if houses.nil? || houses.empty?

      houses = houses.map { |house| house.try(:houseName) }.compact.to_sentence

      [create_description_list_item(term: 'procedure-steps.houses', descriptions: [houses])]
    end

    def list_components
      [].tap do |components|
        components << CardFactory.new(heading_text: 'procedure-steps.subsidiary-resources.work-packages', heading_translation_url: procedure_step_work_packages_path(@procedure_step.try(:graph_id))).build_card
      end
    end

    def section_components
      [ComponentSerializer::ListComponentSerializer.new(display: 'generic', display_data: [display_data(component: 'list', variant: 'block')], components: list_components).to_h]
    end

    def heading_content
      {}.tap do |hash|
        hash[:subheading] = ContentDataHelper.content_data(content: 'procedure-steps.subheading', link: procedure_steps_path)
        hash[:heading] = title
        hash[:context] = @procedure_step.try(:procedureStepDescription)
      end
    end
  end
end
