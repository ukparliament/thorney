require_relative '../rails_helper'

RSpec.describe PaperTypesListComponentsFactory, type: :serializer, vcr: true do
  let(:response) { Parliament::Request::UrlRequest.new(base_url:   ENV['PARLIAMENT_BASE_URL'],
                                                       builder:    Parliament::Builder::NTripleResponseBuilder,
                                                       decorators: Parliament::Grom::Decorator).group_by_id.get }

  let(:group) { response.filter('https://id.parliament.uk/schema/Group').first }

  context 'with a group' do
    it 'creates two cards with a group paper types link' do
      allow(ComponentSerializer::CardComponentSerializer).to receive(:new)

      described_class.build_components(group: group)

      expect(ComponentSerializer::CardComponentSerializer).to have_received(:new).with(name: 'card__generic', data: { heading: { "data" => { "content" => "<a href=\"/groups/7dSvuueH/made-available/availability-types/laid-papers/paper-types/proposed-negative-statutory-instruments\">Proposed negative statutory instruments</a>", "size" => 2 }, "name" => "heading" }} )
      expect(ComponentSerializer::CardComponentSerializer).to have_received(:new).with(name: 'card__generic', data: { heading: { "data" => { "content" => "<a href=\"/groups/7dSvuueH/made-available/availability-types/laid-papers/paper-types/statutory-instruments\">Statutory instruments</a>", "size" => 2 }, "name" => "heading" }} )
    end
  end

  context 'without a group' do
    it 'creates two cards with a work package paper types link' do
      allow(ComponentSerializer::CardComponentSerializer).to receive(:new)

      described_class.build_components

      expect(ComponentSerializer::CardComponentSerializer).to have_received(:new).with(name: 'card__generic', data: { heading: { "data" => { "content" => "<a href=\"/work-packages/paper-types/proposed-negative-statutory-instruments\">Proposed negative statutory instruments</a>", "size" => 2 }, "name" => "heading" }} )
      expect(ComponentSerializer::CardComponentSerializer).to have_received(:new).with(name: 'card__generic', data: { heading: { "data" => { "content" => "<a href=\"/work-packages/paper-types/statutory-instruments\">Statutory instruments</a>", "size" => 2 }, "name" => "heading" }} )
    end
  end
end
