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
        header_components: header_components,
        main_components:   main_components,
        footer_components: footer_components
      }
    end

    def main_components
      content
    end

    def header_components
      header = []

      header << skip_to_content
      header << cookie_banner
      header << status_banner
      header << header_component

      header
    end

    def skip_to_content
      name_and_data_hash('skip-to-content', 'skip-to-content.skip-to-content')
    end

    def cookie_banner
      data = {
        parliament_uses_cookies: 'cookie-banner.parliament-uses-cookies',
        find_out_more:           'cookie-banner.find-out-more'
      }

      name_and_data_hash('cookie-banner', data)
    end

    def status_banner
      data = {
        beta:            'status-banner.beta',
        pages_tested:    'status-banner.pages-tested',
        give_feedback:   'status-banner.give-feedback',
        improve_them:    'status-banner.improve-them',
        go_to:           'status-banner.go-to',
        current_website: 'status-banner.current-website'
      }

      name_and_data_hash('status-banner', data)
    end

    def header_component
      data = {
        components: name_and_data_hash('header-component', 'header-component.uk-parliament')
      }

      name_and_data_hash('header', data)
    end

    def name_and_data_hash(name, data)
      { name: name, data: data }
    end

    def title
      raise 'You must implement #title'
    end

    def footer_components
      [name_and_data_hash('footer', 'footer')]
    end
  end
end
