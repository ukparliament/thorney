class WorkPackageListComponentsFactory
  class << self
    include Rails.application.routes.url_helpers
    include ListDescriptionHelper
    include LayingDateHelper

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

    def description_list_items(work_package)
      laying_date = LayingDateHelper.get_date(work_package)

      [].tap do |items|
        items << (procedure_description_item(work_package) if work_package&.procedure)
        items << (date_description_item(laying_date) if laying_date)
      end
    end

    def procedure_description_item(work_package)
      {
        'term':        { 'content': 'laid-thing.procedure' },
        'description': [{ 'content': work_package&.procedure.try(:procedureName) }]
      }
    end

    def date_description_item(laying_date)
      {
        term:        { content: 'laid-thing.laid-date' },
        description: [ContentDataHelper.content_data(content: 'shared.time-html', datetime_value: I18n.l(laying_date, format: :datetime_format), date: I18n.l(laying_date))]
      }
    end
  end
end
