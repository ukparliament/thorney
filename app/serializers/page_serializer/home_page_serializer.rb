module PageSerializer
  class HomePageSerializer < PageSerializer::BasePageSerializer
    private

    def meta
      super(title: t('home.title'))
    end

    def content
      [].tap do |content|
        content << ComponentSerializer::HeroComponentSerializer.new(components: hero_components, content_flag: true).to_h
        content << ComponentSerializer::SectionComponentSerializer.new(components: section_components, type: 'section', display_data: [display_data(component: 'section', variant: 'major'), display_data(component: 'section', variant: 'wide')]).to_h
      end
    end

    def hero_components
      [].tap do |content|
        content << ComponentSerializer::Heading1ComponentSerializer.new(heading: 'home.hero.heading').to_h
        content << ComponentSerializer::ParagraphComponentSerializer.new(content: ['home.hero.building-new-website', 'home.hero.follow-beta-progress']).to_h
      end
    end

    def section_components
      [].tap do |content|
        content << heading_serializer(content: 'home.mps-and-lords.heading')
        content << list_serializer(components: mps_lords_list_components)
        content << heading_serializer(content: 'home.parliament-activity.heading')
        content << list_serializer(components: parliament_activity_list_components)
        content << heading_serializer(content: 'home.guides.heading')
        content << list_serializer(components: [card(heading_content: ContentDataHelper.content_data(content: 'home.guides.guide-to-procedure.heading', link: collection_path('6i8XQAfD')), paragraph_content: 'home.guides.guide-to-procedure.find')])
      end
    end

    def heading_serializer(content: nil)
      ComponentSerializer::HeadingComponentSerializer.new(content: content, size: 2).to_h
    end

    def list_serializer(components: nil)
      ComponentSerializer::ListComponentSerializer.new(display: 'generic', display_data: [display_data(component: 'list', variant: 'block'), display_data(component: 'list', variant: '3')], components: components).to_h
    end

    def mps_lords_list_components
      [].tap do |content|
        content << card(heading_content: ContentDataHelper.content_data(content: 'home.mps-and-lords.mps.heading', link: mps_path), paragraph_content: 'home.mps-and-lords.mps.find')
        content << card(heading_content: ContentDataHelper.content_data(content: 'home.mps-and-lords.lords.heading', link: house_members_current_a_z_letter_path(HousesHelper.lords_id, 'a')), paragraph_content: 'home.mps-and-lords.lords.find')
        content << card(heading_content: ContentDataHelper.content_data(content: 'home.mps-and-lords.constituencies.heading', link: find_your_constituency_path), paragraph_content: 'home.mps-and-lords.constituencies.find')
        content << card(heading_content: ContentDataHelper.content_data(content: 'home.mps-and-lords.parties-and-groups.heading', link: house_parties_current_path(HousesHelper.commons_id)), paragraph_content: 'home.mps-and-lords.parties-and-groups.find')
      end
    end

    def parliament_activity_list_components
      [].tap do |content|
        content << card(heading_content: ContentDataHelper.content_data(content: 'home.parliament-activity.statutory-instruments.heading', link: find_a_statutory_instrument_path), paragraph_content: 'home.parliament-activity.statutory-instruments.find')
        content << card(heading_content: ContentDataHelper.content_data(content: 'home.parliament-activity.treaties.heading', link: treaties_path), paragraph_content: 'home.parliament-activity.treaties.find')
      end
    end

    def card(heading_content: nil, heading_link: nil, paragraph_content: nil)
      hash = {}
      hash['heading'] = ComponentSerializer::HeadingComponentSerializer.new(content: heading_content, size: 3, link: heading_link).to_h
      hash['paragraph'] = ComponentSerializer::ParagraphComponentSerializer.new(content: [paragraph_content]).to_h
      ComponentSerializer::CardComponentSerializer.new(name: 'card__generic', data: hash).to_h
    end
  end
end
