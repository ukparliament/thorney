module PageSerializer
  class LaidThingShowPageSerializer < PageSerializer::BasePageSerializer
    # Initialise a Laid Thing show page serializer.
    #
    # @param [ActionDispatch::Request] request the current request object.
    # @param [<Grom::Node>] laid_thing a Grom::Node object of type LaidThing.
    # @param [Array<Hash>] data_alternates array containing the href and type of the alternative data urls.
    def initialize(request: nil, laid_thing:, data_alternates: nil)
      @laid_thing    = laid_thing
      @work_package  = @laid_thing.work_package
      @laying_body   = @laid_thing&.laying&.body
      @laying_person = @laid_thing&.laying&.person
      @procedure     = @work_package&.procedure

      super(request: request, data_alternates: data_alternates)
    end

    private

    def content; end

    def parent_child_objects
      [].tap do |components|
        components << object_heading_paragraph(3, 'laid-thing.work-package', "<a href='/work-packages/#{@work_package&.graph_id}'>#{@work_package&.graph_id}</a>")
        components << object_heading_paragraph(4, 'laid-thing.procedure', "<a href='/procedures/#{@procedure&.graph_id}'>#{@procedure&.name}</a>")
        components << object_heading_paragraph(3, 'laid-thing.laying', @laid_thing&.laying&.graph_id)
        components << object_heading_paragraph(4, 'laid-thing.laid-date', l(@laid_thing&.laying&.date))
        components << object_heading_paragraph(4, 'laid-thing.laying-body', @laying_body&.name)
        components << object_heading_paragraph(4, 'laid-thing.laying-person', @laying_person&.display_name)
        components << object_heading_paragraph(3, 'laid-thing.web-link', "<a href='#{@laid_thing.web_link}'>#{@laid_thing.web_link}</a>")
      end.flatten
    end

    def object_heading_paragraph(heading_size, heading_content, paragraph_content)
      [].tap do |components|
        components << ComponentSerializer::HeadingComponentSerializer.new(content: heading_content, size: heading_size).to_h
        components << ComponentSerializer::ParagraphComponentSerializer.new(content: [{ content: paragraph_content }]).to_h
      end
    end

    def section_objects
      [].tap do |components|
        components << ComponentSerializer::HeadingComponentSerializer.new(content: 'laid-thing.objects', size: 2).to_h
        components << parent_child_objects
        components << ComponentSerializer::HeadingComponentSerializer.new(content: connected_statutory_instruments_title, size: 3).to_h
        components << ComponentSerializer::ListComponentSerializer.new(display: 'generic', display_data: [display_data(component: 'list')], components: connected_statutory_instruments).to_h
      end.flatten
    end
  end
end
