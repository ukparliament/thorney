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
        components << ComponentSerializer::SectionComponentSerializer.new(components: section_primary_components, type: 'primary').to_h
        components << ComponentSerializer::SectionComponentSerializer.new(components: section_links, type: 'section').to_h
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

      [create_description_list_item('procedure-steps.houses', [houses])]
    end

    def heading_content
      {}.tap do |hash|
        hash[:subheading_content] = 'procedure-steps.procedure-step'
        hash[:subheading_data] = { link: procedure_steps_path }
        hash[:heading_content] = title
        hash[:context_content] = @procedure_step.try(:procedureStepDescription)
      end
    end

    def section_links
      [].tap do |component|
        component << ComponentSerializer::ParagraphComponentSerializer.new(content: [ContentDataHelper.content_data(content: 'procedure-steps.subsidiary-resources.work-packages', link: procedure_step_work_packages_path(@procedure_step.graph_id))]).to_h
      end
    end
  end
end
