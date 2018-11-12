require_relative '../rails_helper'

RSpec.describe WorkPackageListComponentsFactory, type: :serializer, vcr: true do
  let(:response) { Parliament::Request::UrlRequest.new(base_url:   ENV['PARLIAMENT_BASE_URL'],
                                                      builder:    Parliament::Builder::NTripleResponseBuilder,
                                                      decorators: Parliament::Grom::Decorator).work_package_current.get }

  let(:work_packages) { response.filter('https://id.parliament.uk/schema/WorkPackage') }

  let(:grouping_block) { proc { |work_package| LayingDateHelper.get_date(work_package) } }

  context '#build_components' do
    context 'where an incorrect date_type is provided' do
      it 'returns a card component with no date description item' do
        allow(ComponentSerializer::CardComponentSerializer).to receive(:new)

        described_class.build_components(work_packages: work_packages, date_type: :end_date, grouping_block: grouping_block)

        expect(ComponentSerializer::CardComponentSerializer).to have_received(:new).with(name: 'card__generic', data: { heading: { "data" => { "content" => "<a href=\"/work-packages/rlJaCEwJ\">workPackagedThingName - 1</a>", "size" => 2 }, "name" => "heading" }, list_description: { "data" => { "items" => [{ "description" => [{ "content" => "procedureName - 1" }], "term" => { "content" => "laid-thing.procedure" } }, nil] }, "name" => "list__description" } })
      end
    end

    it 'gives the correct data to the serializer' do
      allow(ComponentSerializer::CardComponentSerializer).to receive(:new)

      described_class.build_components(work_packages: work_packages, date_type: :laying_date, grouping_block: grouping_block)

      expect(ComponentSerializer::CardComponentSerializer).to have_received(:new).with(name: 'card__generic', data: { heading: { "data" => { "content" => "<a href=\"/work-packages/rlJaCEwJ\">workPackagedThingName - 1</a>", "size" => 2 }, "name" => "heading" }, list_description: { "data" => { "items" => [{ "description" => [{ "content" => "procedureName - 1" }], "term" => { "content" => "laid-thing.procedure" } }, { "description" => [{ "content" => "shared.time-html", "data" => { "date" => "23 April 2018", "datetime-value" => "2018-04-23" } }], "term" => { "content" => "laid-thing.laid-date" } }] }, "name" => "list__description" } })
    end
  end

  context '#sort_and_build_components' do
    context 'where no date_type is provided' do
      it 'raises an error' do
        expect { described_class.sort_and_build_components(work_packages: work_packages) }.to raise_error('You need to provide a valid date_type')
      end
    end

    context 'where an incorrect date_type is provided' do
      it 'raises an error' do
        expect { described_class.sort_and_build_components(work_packages: work_packages, date_type: :end_date) }.to raise_error('You need to provide a valid date_type')
      end
    end

    context 'where date_type is laying_date' do
      it 'gives the correct data to the serializer' do
        allow(ComponentSerializer::CardComponentSerializer).to receive(:new)

        described_class.sort_and_build_components(work_packages: work_packages, date_type: :laying_date)

        expect(ComponentSerializer::CardComponentSerializer).to have_received(:new).with(name: 'card__generic', data: { heading: { "data" => { "content" => "<a href=\"/work-packages/rlJaCEwJ\">workPackagedThingName - 1</a>", "size" => 2 }, "name" => "heading" }, list_description: { "data" => { "items" => [{ "description" => [{ "content" => "procedureName - 1" }], "term" => { "content" => "laid-thing.procedure" } }, { "description" => [{ "content" => "shared.time-html", "data" => { "date" => "23 April 2018", "datetime-value" => "2018-04-23" } }], "term" => { "content" => "laid-thing.laid-date" } }] }, "name" => "list__description" } })
      end
    end

    context 'where date_type is business_item_date' do
      it 'gives the correct data to the serializer' do
        allow(ComponentSerializer::CardComponentSerializer).to receive(:new)

        described_class.sort_and_build_components(work_packages: work_packages, date_type: :business_item_date)

        expect(ComponentSerializer::CardComponentSerializer).to have_received(:new).with(name: 'card__generic', data: { heading: { "data" => { "content" => "<a href=\"/work-packages/PsB0pq0l\">workPackagedThingName - 1</a>", "size" => 2 }, "name" => "heading" }, list_description: { "data" => { "items" => [{ "description" => [{ "content" => "procedureName - 1" }], "term" => { "content" => "laid-thing.procedure" } }, { "description" => [{ "content" => "shared.time-html", "data" => { "date" => "9 May 2018", "datetime-value" => "2018-05-09" } }], "term" => { "content" => "procedure-steps.subsidiary-resources.actualised-date" } }] }, "name" => "list__description" } })
      end
    end

  end
end
