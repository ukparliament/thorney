module PartialSerializer
  # This serializer initializes all the components required for the header of a page.
  class HeaderComponentsPartialSerializer < BaseSerializer
    def to_h
      header = []

      header << skip_to_content
      header << cookie_banner
      header << status_banner
      header << header_component

      header
    end

    private

    def skip_to_content
      ComponentSerializer::LinkComponentSerializer.new(link: '#content', display_data: skip_to_content_display_data, selector: 'skiplink', content: 'shared.header.skip-to-content').to_h
    end

    def skip_to_content_display_data
      [display_data(component: 'skip-to-content')]
    end

    def cookie_banner
      ComponentSerializer::StatusComponentSerializer.new(type: 'banner', display_data: cookie_banner_display_data, selector: 'cookie', components: cookie_banner_components).to_h
    end

    def cookie_banner_display_data
      [
        display_data(component: 'status', variant: 'banner'),
        display_data(component: 'theme', variant: 'caution'),
        display_data(component: 'cookie')
      ]
    end

    def cookie_banner_components
      [ComponentSerializer::ParagraphComponentSerializer.new([{ content: 'shared.header.cookie-banner-text', link: '/meta/cookie-policy' }]).to_h]
    end

    def status_banner
      ComponentSerializer::StatusComponentSerializer.new(type: 'banner', display_data: status_banner_display_data, components: status_banner_components).to_h
    end

    def status_banner_display_data
      [
        display_data(component: 'status', variant: 'banner')
      ]
    end

    def status_banner_components
      [ComponentSerializer::ListComponentSerializer.new(display: 'generic', contents: ['shared.header.pages-being-tested', 'shared.header.current-website'], display_data: [display_data(component: 'list', variant: 'inline')], type: ComponentSerializer::ListComponentSerializer::Type::UNORDERED).to_h]
    end

    def header_component
      ComponentSerializer::HeaderComponentSerializer.new(components: [header_link]).to_h
    end

    def header_link
      ComponentSerializer::LinkComponentSerializer.new(link: '/', display_data: header_display_data, label: 'shared.header.label', components: header_link_components).to_h
    end

    def header_display_data
      [display_data(component: 'uk_parliament')]
    end

    def header_link_components
      [name_and_data_hash('icon__uk-parliament', 'shared.header.label')]
    end

    def name_and_data_hash(name, data)
      { name: name, data: data }
    end
  end
end
