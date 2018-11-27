module PageSerializer
  class CommitteePrototypeShowPageSerializer < PageSerializer::BasePageSerializer
    def initialize(request: nil, committee:, business:, memberships:, parent:, children:, images:)
      @committee   = committee
      @business    = business
      @memberships = memberships
      @parent      = parent
      @children    = children
      @images      = images

      super(request: request, data_alternates: nil)
    end

    private

    def meta
      super(title: title)
    end

    def title
      @committee.try(:name) || I18n.t('no_name')
    end

    def content
      [].tap do |components|
        components << ComponentSerializer::SectionComponentSerializer.new(components: section_primary_components, type: 'primary', content_flag: true).to_h
        components << ComponentSerializer::SectionComponentSerializer.new(components: section_components, type: 'section').to_h
      end
    end

    def section_primary_components
      [].tap do |components|
        components << ComponentSerializer::Heading1ComponentSerializer.new(heading_content).to_h
        components << ComponentSerializer::ListDescriptionComponentSerializer.new(items: meta_info, meta: true).to_h unless meta_info.empty?
      end
    end

    def heading_content
      date_range = CommitteePrototypeService.generate_committee_date_range(@committee)
      {}.tap do |hash|
        hash[:subheading] = ContentDataHelper.content_data(content: link_to(I18n.t('committee_prototype.index.title'), committees_prototype_path))
        hash[:heading] = title
        hash[:context] = date_range if date_range
      end
    end

    def section_components
      [].tap do |components|
        if @committee.try(:purpose)
          components << ComponentSerializer::HeadingComponentSerializer.new(content: I18n.t('committee_prototype.show.purpose'), size: 2).to_h
          components << ComponentSerializer::ParagraphComponentSerializer.new(content: [@committee.purpose]).to_h if @committee.try(:purpose)
        end

        components << ComponentSerializer::HeadingComponentSerializer.new(content: I18n.t('committee_prototype.show.business.title'), size: 2).to_h
        components << ComponentSerializer::ListComponentSerializer.new(display: 'generic', display_data: [display_data(component: 'list', variant: 'block')], components: [
            CardFactory.new(
                heading_text: I18n.t('committee_prototype.show.business.current_business'),
                heading_url: committee_prototype_business_current_path(committee_id: @committee.try(:id))
            ).build_card,
            CardFactory.new(
                heading_text: I18n.t('committee_prototype.show.business.former_business'),
                heading_url: committee_prototype_business_former_path(committee_id: @committee.try(:id))
            ).build_card
        ]).to_h

        if @memberships.present?
          components << ComponentSerializer::HeadingComponentSerializer.new(content: I18n.t('committee_prototype.show.members'), size: 2).to_h
          components << ComponentSerializer::ListComponentSerializer.new(display: 'generic', display_data: [display_data(component: 'list', variant: 'block')], components: members_cards).to_h
        end
      end
    end

    def meta_info
      house_string = if @committee.try(:isCommons) && @committee.try(:isLords)
                       'both'
                     elsif @committee.try(:isCommons)
                       'commons'
                     elsif @committee.try(:isLords)
                       'lords'
                     end
      house_string = I18n.t("committee_prototype.card.small.#{house_string}") if house_string

      [].tap do |items|
        items << create_description_list_item(term: I18n.t('committee_prototype.show.meta.house'), descriptions: [house_string]) if house_string
        items << create_description_list_item(term: I18n.t('committee_prototype.show.meta.lead_house'), descriptions: [@committee.category.try(:name)]) if @committee.try(:lea)
        items << create_description_list_item(term: I18n.t('committee_prototype.show.meta.category'), descriptions: [@committee.category.try(:name)]) if @committee.try(:category)
        items << create_description_list_item(term: I18n.t('committee_prototype.show.meta.type'), descriptions: @committee.committeeTypes.map { |type| type.try(:name) }.compact) if @committee.try(:committeeTypes)
        items << create_description_list_item(term: I18n.t('committee_prototype.show.meta.commons_appointment'), descriptions: [TimeHelper.time_translation(date_first: DateTime.parse(@committee.dateCommonsAppointed))]) if @committee.try(:dateCommonsAppointed)
        items << create_description_list_item(term: I18n.t('committee_prototype.show.meta.lords_appointment'), descriptions: [TimeHelper.time_translation(date_first: DateTime.parse(@committee.dateLordsAppointed))]) if @committee.try(:dateLordsAppointed)
        items << create_description_list_item(term: I18n.t('committee_prototype.show.meta.parent_committee'), descriptions: [link_to(@parent.try(:name), committee_prototype_path(@parent.id))]) if @parent
        items << create_description_list_item(term: I18n.t('committee_prototype.show.meta.child_committees'), descriptions: [children_links]) if @children
        items << create_description_list_item(term: I18n.t('committee_prototype.show.meta.contact_email'),  descriptions: [ActionController::Base.helpers.mail_to(@committee.email, @committee.email)]) if @committee.try(:email)
        items << create_description_list_item(term: I18n.t('committee_prototype.show.meta.contact_phone'),  descriptions: [@committee.phone]) if @committee.try(:phone)
      end.compact
    end

    def children_links
      @children.map { |child| link_to(child.name, committee_prototype_path(child.id)) }
    end

    def members_cards
      @memberships.map do |membership|
        next unless membership.try(:value)
        membership = membership.try(:value)

        # Get the name of a current role
        current_roles = membership.roles.select { |role| role.try(:endDate).nil? } if membership.try(:roles)
        if current_roles.present?
          chair = current_roles.select { |role| role.try(:role).try(:isChair) }
          nonchair = current_roles.select { |role| !role.try(:role).try(:isChair) }

          small = [chair, nonchair].flatten.compact.map { |role| role.try(:role).try(:name) }.to_sentence
        end

        name = membership.try(:name) || I18n.t('no_name')
        paragraph = membership.try(:party)

        id = membership.try(:mnisId)
        url = people_lookup_path(source: 'mnisId', id: id) if id

        image_url = 'https://static.parliament.uk/pugin/1.11.6/images/placeholder_members_image.png' # Placeholder image
        if id
          image_id = @images[id.to_s]
          image_url = "https://api.parliament.uk/photo/#{image_id}.jpeg?crop=CU_1:1&width=186&quality=80" if image_id
        end
        figure = ComponentSerializer::FigureComponentSerializer.new(display_data: display_data(component: 'avatar', variant: 'round'), link: url, img: {source: image_url}).to_h

        CardFactory.new(
            small: small,
            heading_text: name,
            heading_url: url,
            paragraph_content: [paragraph],
            description_list_content: nil,
            figure: figure
        ).build_card
      end
    end
  end
end
