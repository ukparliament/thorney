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
        content << ComponentSerializer::HeroComponentSerializer.new(hero_components, content_flag: true).to_h
        content << ComponentSerializer::SectionComponentSerializer.new(section_components, type: 'section', display_data: [display_data(component: 'section', variant: 'major'), display_data(component: 'section', variant: 'wide')]).to_h
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
        content << list_serializer(components: parliament_activity_list_components)
        content << heading_serializer(translation_key: 'home.guides.heading')
        content << list_serializer(components: guides_list_components)
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
        content << ComponentSerializer::CardComponentSerializer.new('card__generic', card(heading_content: 'home.mps-and-lords.mps.heading', heading_size: 3, heading_link: '/mps', paragraph_content: 'home.mps-and-lords.mps.find')).to_h
        content << ComponentSerializer::CardComponentSerializer.new('card__generic', card(heading_content: 'home.mps-and-lords.lords.heading', heading_size: 3, heading_link: '/houses/WkUWUBMx/members/current/a-z/a', paragraph_content: 'home.mps-and-lords.lords.find')).to_h
        content << ComponentSerializer::CardComponentSerializer.new('card__generic', card(heading_content: 'home.mps-and-lords.constituencies.heading', heading_size: 3, heading_link: '/find-your-constituency', paragraph_content: 'home.mps-and-lords.constituencies.find')).to_h
        content << ComponentSerializer::CardComponentSerializer.new('card__generic', card(heading_content: 'home.mps-and-lords.parties-and-groups.heading', heading_size: 3, heading_link: '/houses/1AFu55Hs/parties/current', paragraph_content: 'home.mps-and-lords.parties-and-groups.find')).to_h
      end
    end

    def card(heading_content: nil, heading_size: nil, heading_link: nil, paragraph_content: nil)
      {}.tap do |hash|
        hash[:heading] = ComponentSerializer::HeadingComponentSerializer.new(content: [heading_content], size: heading_size, link: heading_link).to_h
        hash[:paragraph] = ComponentSerializer::ParagraphComponentSerializer.new([{ content: paragraph_content }]).to_h
      end
    end

    def parliament_activity_list_components
      [].tap do |content|
        content << ComponentSerializer::CardComponentSerializer.new('card__generic', card(heading_content: 'home.parliament-activity.statutory-instruments.heading', heading_size: 3, heading_link: '/statutory-instruments', paragraph_content: 'home.parliament-activity.statutory-instruments.find')).to_h
      end
    end

    def guides_list_components
      [].tap do |content|
        content << ComponentSerializer::CardComponentSerializer.new('card__generic', card(heading_content: 'home.guides.guide-to-procedure.heading', heading_size: 3, heading_link: '/collections/6i8XQAfD', paragraph_content: 'home.guides.guide-to-procedure.find')).to_h
      end
    end
  end
end
