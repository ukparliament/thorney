module PartialSerializer
  # This serializer initializes all the components required for the header of a page.
  class HeaderComponentsPartialSerializer < BaseSerializer
    def initialize(include_global_search: true)
      @include_global_search = include_global_search
    end

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
      [ComponentSerializer::ParagraphComponentSerializer.new(content: [ContentDataHelper.content_data(content: 'shared.header.cookie-banner-text', link: '/meta/cookie-policy')]).to_h]
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
      [ComponentSerializer::ParagraphComponentSerializer.new(content: ['shared.header.beta-status']).to_h]
    end

    def header_component
      ComponentSerializer::HeaderComponentSerializer.new(components: header_components).to_h
    end

    # Allows for the option of not including global search if the default method found in the base page serializer is overridden.
    def header_components
      [].tap do |components|
        components << header_link
        components << header_search if @include_global_search
      end
    end

    def header_link
      ComponentSerializer::LinkComponentSerializer.new(link: root_path, display_data: header_display_data, label: 'shared.header.label', components: header_link_components).to_h
    end

    def header_search
      ComponentSerializer::SearchFormComponentSerializer.new(components: [ComponentSerializer::SearchIconComponentSerializer.new.to_h], global: true, hide_label: true, search_action: search_path).to_h
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
