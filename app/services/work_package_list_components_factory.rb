class WorkPackageListComponentsFactory
  class << self
    include Rails.application.routes.url_helpers
    include ListDescriptionHelper
    include LayingDateHelper

    def sort_and_build_components(work_packages: nil, group_by: nil)
      grouping_block = nil

      grouping_block = laying_date_block if group_by == :laying_date

      sorted_work_packages = GroupSortHelper.group_and_sort(work_packages, group_block: grouping_block, key_sort_descending: true, sort_method_symbols: %i[work_packaged_thing workPackagedThingName])

      build_components(work_packages: sorted_work_packages)
    end

    def build_components(work_packages: nil)
      work_packages.map do |work_package|
        CardFactory.new(
          heading_text:             work_package&.work_packaged_thing.try(:workPackagedThingName),
          heading_url:              work_package_path(work_package.graph_id),
          description_list_content: description_list_items(work_package)
        ).build_card
      end
    end

    private

    def laying_date_block
      proc { |work_package| LayingDateHelper.get_date(work_package) }
    end

    def description_list_items(work_package)
      laying_date = laying_date_block.call(work_package)

      [].tap do |items|
        items << (create_description_list_item(term: 'laid-thing.procedure', descriptions: [work_package&.procedure.try(:procedureName)]) if work_package&.procedure)
        items << (create_description_list_item(term: 'laid-thing.laid-date', descriptions: [ContentDataHelper.content_data(content: 'shared.time-html', datetime_value: I18n.l(laying_date, format: :datetime_format), date: I18n.l(laying_date))]) if laying_date)
      end
    end
  end
end
