class WorkPackageListComponentsFactory
  class << self
    include Rails.application.routes.url_helpers
    include ListDescriptionHelper
    include LayingDateHelper

    # Types of date which can be used for grouping
    module DateType
      LAYING_DATE        = :laying_date
      BUSINESS_ITEM_DATE = :business_item_date
    end

    # Groups, sorts and builds list components for work packages
    #
    # @param [Array] work_packages list of work packages
    # @param [Symbol] date_type type of date to group by and use in the list component - available types are in the DateType module
    #
    # @return [Array] array of Card components populated with the work package data
    def sort_and_build_components(work_packages: nil, date_type: nil)
      grouping_block = case date_type
                       when DateType::LAYING_DATE
                         laying_date_block
                       when DateType::BUSINESS_ITEM_DATE
                         business_item_date_block
                       else
                         raise StandardError, 'You need to provide a valid date_type'
                       end

      sorted_work_packages = GroupSortHelper.group_and_sort(work_packages, group_block: grouping_block, key_sort_descending: true, sort_method_symbols: %i[work_packaged_thing workPackagedThingName])

      build_components(work_packages: sorted_work_packages, date_type: date_type, grouping_block: grouping_block)
    end

    # Builds list components for work packages
    #
    # @param [Array] work_packages list of work packages
    # @param [Symbol] date_type type of date to use in the list component
    # @param [Block] grouping_block block to generate the date in the list component
    #
    # @return [Array] array of Card components populated with the work package data
    def build_components(work_packages: nil, date_type: nil, grouping_block: nil)
      work_packages.map do |work_package|
        CardFactory.new(
          heading_text:             work_package&.work_packaged_thing.try(:workPackagedThingName),
          heading_url:              work_package_path(work_package.graph_id),
          description_list_content: description_list_items(work_package, date_type, grouping_block)
        ).build_card
      end
    end

    private

    def laying_date_block
      proc { |work_package| LayingDateHelper.get_date(work_package) }
    end

    def business_item_date_block
      proc { |work_package| work_package&.business_item&.date }
    end

    def description_list_items(work_package, date_type, grouping_block)
      [].tap do |items|
        items << (create_description_list_item(term: 'laid-thing.procedure', descriptions: [work_package&.procedure.try(:procedureName)]) if work_package&.procedure)
        items << (date_description_list_item(work_package, date_type, grouping_block) if date_type && grouping_block)
      end
    end

    def date_description_list_item(work_package, date_type, grouping_block)
      date = grouping_block.call(work_package)

      translation_string = case date_type
                           when DateType::LAYING_DATE
                             'laid-thing.laid-date'
                           when DateType::BUSINESS_ITEM_DATE
                             'procedure-steps.subsidiary-resources.actualised-date'
                           end

      create_date_description_list_item(translation_string, date) if date && translation_string
    end

    def create_date_description_list_item(translation_string, date)
      create_description_list_item(term: translation_string, descriptions: [TimeHelper.time_translation(date_first: date)])
    end
  end
end
