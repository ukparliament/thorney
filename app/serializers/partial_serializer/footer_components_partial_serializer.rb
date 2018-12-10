module PartialSerializer
  # This serializer initializes all the components required for the footer of a page.
  class FooterComponentsPartialSerializer < BaseSerializer
    def to_h
      [{ name: 'footer', data: footer_components_data }]
    end

    def footer_components_data
      contents = [
        'shared.footer.current-website',
        ContentDataHelper.content_data(content: 'shared.footer.cookie-policy', link: '/meta/cookie-policy'),
        'shared.footer.data-protection-privacy'
      ]

      {
        heading:      ComponentSerializer::HeadingComponentSerializer.new(content: 'shared.meta.title', size: 2).to_h,
        list_generic: ComponentSerializer::ListComponentSerializer.new(display: 'generic', type: ComponentSerializer::ListComponentSerializer::Type::UNORDERED, display_data: footer_components_display_data, contents: contents).to_h
      }
    end

    def footer_components_display_data
      [display_data(component: 'list')]
    end
  end
end
