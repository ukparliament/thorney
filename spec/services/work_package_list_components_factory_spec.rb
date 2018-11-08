require_relative '../rails_helper'

RSpec.describe WorkPackageListComponentsFactory, type: :serializer, vcr: true do
  let(:response) { Parliament::Request::UrlRequest.new(base_url:   ENV['PARLIAMENT_BASE_URL'],
                                                      builder:    Parliament::Builder::NTripleResponseBuilder,
                                                      decorators: Parliament::Grom::Decorator).work_package_current.get }

  let(:work_packages) { response.filter('https://id.parliament.uk/schema/WorkPackage') }

  context '#build_components' do
    it 'gives the correct data to the serializer' do
      allow(ComponentSerializer::CardComponentSerializer).to receive(:new)

      described_class.build_components(work_packages: work_packages)

      expect(ComponentSerializer::CardComponentSerializer).to have_received(:new).with(name: 'card__generic', data: { heading: { "data" => { "content" => "workPackagedThingName - 1", "link" => "/work-packages/rlJaCEwJ", "size" => 2 }, "name" => "heading" }, list_description: { "data" => { "items" => [{ "description" => [{ "content" => "procedureName - 1" }], "term" => { "content" => "laid-thing.procedure" } }, { "description" => [{ "content" => "shared.time-html", "data" => { "date" => "23 April 2018", "datetime-value" => "2018-04-23" } }], "term" => { "content" => "laid-thing.laid-date" } }] }, "name" => "list__description" } })
    end
  end

  context '#sort_and_build_components' do
    it 'gives the correct data to the serializer' do
      allow(ComponentSerializer::CardComponentSerializer).to receive(:new)

      described_class.sort_and_build_components(work_packages: work_packages, group_by: :laying_date)

      expect(ComponentSerializer::CardComponentSerializer).to have_received(:new).with(name: 'card__generic', data: { heading: { "data" => { "content" => "workPackagedThingName - 1", "link" => "/work-packages/rlJaCEwJ", "size" => 2 }, "name" => "heading" }, list_description: { "data" => { "items" => [{ "description" => [{ "content" => "procedureName - 1" }], "term" => { "content" => "laid-thing.procedure" } }, { "description" => [{ "content" => "shared.time-html", "data" => { "date" => "23 April 2018", "datetime-value" => "2018-04-23" } }], "term" => { "content" => "laid-thing.laid-date" } }] }, "name" => "list__description" } })
    end
  end
end
