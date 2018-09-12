module PageSerializer
  class HomePageSerializer < PageSerializer::BasePageSerializer
    # Initialise a Home index page serializer.
    #
    # @param [String] opensearch_description_url a description url for the search.
    def initialize(opensearch_description_url: nil)
      @opensearch_description_url = opensearch_description_url
    end

    private

    attr_reader :opensearch_description_url

    def meta
      { title: 'Pretendy Beta.paliament.uk' }
    end

    def content
      [].tap do |content|
        content << ComponentSerializer::HeroComponentSerializer.new(components: hero_components, content_flag: true).to_h
        content << ComponentSerializer::SectionComponentSerializer.new(components: section_components, type: 'section', display_data: [display_data(component: 'section', variant: 'major'), display_data(component: 'section', variant: 'wide')]).to_h
      end
    end

    def hero_components
      [].tap do |content|
        content << ComponentSerializer::Heading1ComponentSerializer.new(heading_content: 'home.hero.heading').to_h
        content << ComponentSerializer::ParagraphComponentSerializer.new([{ content: 'home.hero.building-new-website' }, { content: 'home.hero.follow-beta-progress' }]).to_h
      end
    end

    def section_components
      [].tap do |content|
        content << heading_serializer(translation_key: 'home.mps-and-lords.heading')
        content << list_serializer(components: mps_lords_list_components)
        content << heading_serializer(translation_key: 'home.parliament-activity.heading')
        content << list_serializer(components: [card(heading_content: 'home.parliament-activity.statutory-instruments.heading', heading_link: '/statutory-instruments', paragraph_content: 'home.parliament-activity.statutory-instruments.find')])
        content << heading_serializer(translation_key: 'home.guides.heading')
        content << list_serializer(components: [card(heading_content: 'home.guides.guide-to-procedure.heading', heading_link: '/collections/6i8XQAfD', paragraph_content: 'home.guides.guide-to-procedure.find')])
      end
    end

    def heading_serializer(translation_key: nil)
      ComponentSerializer::HeadingComponentSerializer.new(translation_key: translation_key, size: 2).to_h
    end

    def list_serializer(components: nil)
      ComponentSerializer::ListComponentSerializer.new(display: 'generic', display_data: [display_data(component: 'list', variant: 'block'), display_data(component: 'list', variant: '3')], components: components).to_h
    end

    def mps_lords_list_components
      [].tap do |content|
        content << card(heading_content: 'home.mps-heading', heading_link: '/mps', paragraph_content: 'home.find-all-mps')
        content << card(heading_content: 'home.lords-heading', heading_link: '/houses/WkUWUBMx/members/current/a-z/a', paragraph_content: 'home.find-all-lords')
        content << card(heading_content: 'home.constituencies-heading', heading_link: '/find-your-constituency', paragraph_content: 'home.find-mps-by-area')
        content << card(heading_content: 'home.parties-and-groups-heading', heading_link: '/houses/1AFu55Hs/parties/current', paragraph_content: 'home.find-members-by-party-or-group')
      end
    end

    def card(heading_content: nil, heading_link: nil, paragraph_content: nil)
      data_hash = {}
      data_hash[:heading] = ComponentSerializer::HeadingComponentSerializer.new(content: [heading_content], size: 3, link: heading_link).to_h
      data_hash[:paragraph] = ComponentSerializer::ParagraphComponentSerializer.new(content: [{ content: paragraph_content }]).to_h
      ComponentSerializer::CardComponentSerializer.new(name: 'card__generic', data: data_hash).to_h
    end
  end
end
