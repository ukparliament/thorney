module PageSerializer
  class ProceduresShowPageSerializer < PageSerializer::BasePageSerializer
    # Initialise a Procedures show page serializer.
    #
    # @param [ActionDispatch::Request] request the current request object.
    # @param [<Grom::Node>] procedure a Grom::Node object of type Procedure.
    # @param [Array<Hash>] data_alternates array containing the href and type of the alternative data urls.
    def initialize(request: nil, procedure: nil, data_alternates: nil)
      @procedure = procedure
      super(request: request, data_alternates: data_alternates)
    end

    private

    def meta
      super(title: title)
    end

    def title
      @procedure.try(:procedureName)
    end

    def content
      [].tap do |components|
        components << ComponentSerializer::SectionComponentSerializer.new(components: section_primary_components, type: 'primary').to_h
        components << ComponentSerializer::SectionComponentSerializer.new(components: section_components, type: 'section').to_h
      end
    end

    def section_primary_components
      [].tap do |components|
        components << ComponentSerializer::Heading1ComponentSerializer.new(heading_content).to_h
        components << ComponentSerializer::ParagraphComponentSerializer.new(content: [ContentDataHelper.content_data(content: 'procedures.show.about', procedure: @procedure.try(:procedureName).downcase)]).to_h
      end
    end

    def heading_content
      {}.tap do |hash|
        hash[:subheading] = ContentDataHelper.content_data(content: 'procedures.show.subheading', link: procedures_path)
        hash[:heading] = title || t('no_name')
      end
    end

    def list_components
      [].tap do |components|
        components << CardFactory.new(heading_text: 'procedures.show.subsidiary-resources.work-packages', heading_translation_url: procedure_work_packages_path(@procedure.try(:graph_id))).build_card
      end
    end

    def section_components
      [ComponentSerializer::ListComponentSerializer.new(display: 'generic', display_data: [display_data(component: 'list', variant: 'block')], components: list_components).to_h]
    end
  end
end
