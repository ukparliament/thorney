module PageSerializer
  class LaidThingShowPageSerializer < PageSerializer::BasePageSerializer
    # Initialise a Laid Thing show page serializer.
    #
    # @param [ActionDispatch::Request] request the current request object.
    # @param [<Grom::Node>] laid_thing a Grom::Node object of type LaidThing.
    # @param [Array<Hash>] data_alternates array containing the href and type of the alternative data urls.
    def initialize(request: nil, laid_thing: nil, data_alternates: nil)
      @laid_thing     = laid_thing
      @work_package   = @laid_thing.try(:work_package)
      @laying_body    = @laid_thing.try(:laying).try(:body)
      @laying_person  = @laid_thing.try(:laying).try(:person)
      @procedure      = @work_package.try(:procedure)
      @business_item  = @work_package.try(:business_item)
      @procedure_step = @business_item.try(:procedure_step) if @business_item

      super(request: request, data_alternates: data_alternates)
    end

    def title
      @laid_thing.try(:laidThingName) || t('no_name')
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
        components << CardFactory.new(
          small:                    'laid-thing.procedural-activity',
          heading_text:             @laid_thing.try(:laidThingName) || t('no_name'),
          heading_url:              work_package_path(@work_package.try(:graph_id)),
          description_list_content: work_package_list_description_items
        ).build_card
      end
    end

    def work_package_list_description_items
      [].tap do |items|
        items << create_description_list_item(term: 'laid-thing.procedure', descriptions: [@procedure.try(:procedureName)])
        items << if @business_item && @business_item.try(:date)
                   create_description_list_item(term: @procedure_step.try(:procedureStepName), descriptions: [TimeHelper.time_translation(date_first: @business_item.try(:date))])
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
