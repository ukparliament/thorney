module PartialSerializer
  # This serializer initializes all the components required for the footer of a page.
  class FooterComponentsPartialSerializer < BaseSerializer
    def to_h
      [{ name: 'footer', data: footer_components_data }]
    end

    def footer_components_data
      contents = [
        'footer.current-website',
        { content: 'footer.cookie-policy', link: '/meta/cookie-policy' },
        'footer.data-protection-privacy'
      ]

      {
        'uk-parliament': 'footer.uk-parliament',
        components:      [ComponentSerializer::ListComponentSerializer.new(display: 'generic', type: ComponentSerializer::ListComponentSerializer::Type::UNORDERED, display_data: footer_components_display_data, contents: contents).to_h]
      }
    end

    def footer_components_display_data
      [display_data(component: 'list')]
    end
  end
end
