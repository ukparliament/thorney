module PageSerializer
  class LaidThingShowPageSerializer < PageSerializer::BasePageSerializer
    # Initialise a Laid Thing show page serializer.
    #
    # @param [ActionDispatch::Request] request the current request object.
    # @param [<Grom::Node>] laid_thing a Grom::Node object of type LaidThing.
    # @param [Array<Hash>] data_alternates array containing the href and type of the alternative data urls.
    def initialize(request: nil, laid_thing:, data_alternates: nil)
      @laid_thing    = laid_thing
      @work_package  = @laid_thing.try(:work_package)
      @laying_body   = @laid_thing.try(:laying).try(:body)
      @laying_person = @laid_thing.try(:laying).try(:person)
      @procedure     = @work_package.try(:procedure)
      @business_item = @work_package.try(:business_item)
      @procedure_step = @business_item.try(:procedure_step) if @business_item

      super(request: request, data_alternates: data_alternates)
    end

    def title
      raise StandardError, 'You must implement #title'
    end

    private

    def content
      [].tap do |components|
        components << ComponentSerializer::SectionComponentSerializer.new(components: section_primary_components, type: 'primary', content_flag: true).to_h
        components << ComponentSerializer::SectionComponentSerializer.new(components: work_package_section, type: 'section').to_h if @work_package
      end
    end

    def section_primary_components
      [].tap do |components|
        components << heading1_component
        components << ComponentSerializer::ListDescriptionComponentSerializer.new(items: meta_info, meta: true).to_h unless meta_info.empty?
      end
    end

    def work_package_section
      [].tap do |components|
        components << ComponentSerializer::ListComponentSerializer.new(
          display:      'generic',
          display_data: [display_data(component: 'list', variant: 'block')],
          components:   work_package_list_components
        ).to_h
      end
    end

    def work_package_list_components
      [].tap do |components|
        components << ComponentSerializer::CardComponentSerializer.new(
          name: 'card__generic',
          data: {
            small:            ComponentSerializer::SmallComponentSerializer.new(content: 'laid-thing.procedural-activity').to_h,
            heading:          work_package_card_heading,
            list_description: work_package_list_description
          }
        ).to_h
      end
    end

    def work_package_card_heading
      ComponentSerializer::HeadingComponentSerializer.new(content: link_to(title, work_package_path(@work_package.try(:graph_id))), size: 2).to_h
    end

    def work_package_list_description
      ComponentSerializer::ListDescriptionComponentSerializer.new(items: list_description_items).to_h
    end

    def list_description_items
      [].tap do |items|
        items << { 'term': { 'content': 'Procedure' }, 'description': [{ 'content': @procedure.try(:procedureName) }] }
        items << if @business_item && @business_item.try(:date)
                   {
                     'term':        { 'content': @procedure_step.try(:procedureStepName) },
                     'description': [TimeHelper.time_translation(date_first: @business_item.try(:date))]
                   }
                 end
      end
    end

    def heading1_component
      raise StandardError, 'You must implement #heading1_component'
    end

    def meta_info
      raise StandardError, 'You must implement #meta_info'
    end
  end
end
