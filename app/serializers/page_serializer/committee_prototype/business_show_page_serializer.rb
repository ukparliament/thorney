module PageSerializer
  module CommitteePrototype
    class BusinessShowPageSerializer < PageSerializer::BasePageSerializer
      def initialize(request: nil, committee:, business:)
        @committee   = committee
        @business    = business

        super(request: request, data_alternates: nil)
      end

      private

      def meta
        super(title: title)
      end

      def title
        @business.try(:title) || I18n.t('no_name')
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
        {}.tap do |hash|
          hash[:subheading] = ContentDataHelper.content_data(content: link_to(@committee.try(:name), committee_prototype_path(@committee.try(:id))))
          hash[:heading] = title
          hash[:context] = @business.committeeBusinessType.try(:name) if @business.try(:committeeBusinessType)
        end
      end

      def section_components
        [].tap do |components|
          if @business.try(:scope)
            components << ComponentSerializer::HeadingComponentSerializer.new(content: I18n.t('committee_prototype.business.show.scope'), size: 2).to_h
            components << ComponentSerializer::ParagraphComponentSerializer.new(content: [@business.scope]).to_h
          end
        end
      end

      def meta_info
        [].tap do |items|
          items << create_description_list_item(term: I18n.t('committee_prototype.business.show.meta.open'), descriptions: [I18n.l(DateTime.parse(@business.openDate))]) if @business.try(:openDate)
          items << create_description_list_item(term: I18n.t('committee_prototype.business.show.meta.closed'), descriptions: [I18n.l(DateTime.parse(@business.closedDate))]) if @business.try(:closedDate)
          items << create_description_list_item(term: I18n.t('committee_prototype.business.show.meta.prefix'), descriptions: [I18n.l(DateTime.parse(@business.prefix))]) if @business.try(:prefix)
          items << create_description_list_item(term: I18n.t('committee_prototype.business.show.meta.publication'), descriptions: [I18n.l(DateTime.parse(@business.publicationDateTime))]) if @business.try(:publicationDateTime)
          items << create_description_list_item(term: I18n.t('committee_prototype.business.show.meta.hc_numbers'), descriptions: @business.hcNumbers) if @business.try(:hcNumbers)
          items << create_description_list_item(term: I18n.t('committee_prototype.business.show.meta.hl_numbers'), descriptions: @business.hlNumbers) if @business.try(:hlNumbers)
        end
      end
    end
  end
end
