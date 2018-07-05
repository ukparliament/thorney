module PageSerializer
  # The serializer which all page serializers inherit from.
  class BasePageSerializer < BaseSerializer
    def to_h
      dasherize_keys(hash)
    end

    private

    def hash
      {
        layout:            {
          'template': 'layout'
        },
        title:             title,
        header_components: PartialSerializer::HeaderComponentsPartialSerializer.new.to_h,
        main_components:   main_components,
        footer_components: PartialSerializer::FooterComponentsPartialSerializer.new.to_h
      }
    end

    def main_components
      content
    end

    def title
      raise 'You must implement #title'
    end
  end
end
