require 'rails_helper'

RSpec.describe Groups::MadeAvailable::AvailabilityTypesController, vcr: true do
  describe 'GET index' do
    let(:data_alternates) do
      [{
           href: "#{ENV['PARLIAMENT_BASE_URL']}/group_by_id.nt?group_id=XouN12Ow",
           type: 'application/n-triples'
       },
       {href: "#{ENV['PARLIAMENT_BASE_URL']}/group_by_id.ttl?group_id=XouN12Ow",
        type: 'text/turtle'},
       {href: "#{ENV['PARLIAMENT_BASE_URL']}/group_by_id.tsv?group_id=XouN12Ow",
        type: 'text/tab-separated-values'},
       {href: "#{ENV['PARLIAMENT_BASE_URL']}/group_by_id.csv?group_id=XouN12Ow",
        type: 'text/csv'},
       {href: "#{ENV['PARLIAMENT_BASE_URL']}/group_by_id.rj?group_id=XouN12Ow",
        type: 'application/json+rdf'},
       {href: "#{ENV['PARLIAMENT_BASE_URL']}/group_by_id.json?group_id=XouN12Ow",
        type: 'application/json+ld'},
       {href: "#{ENV['PARLIAMENT_BASE_URL']}/group_by_id.xml?group_id=XouN12Ow",
        type: 'application/rdf+xml'}]
    end

    let(:heading) {'a heading component'}

    before(:each) do
      allow(PageSerializer::ListPageSerializer).to receive(:new)
      allow(ComponentSerializer::Heading1ComponentSerializer).to receive(:new) {heading}

      allow(controller.request).to receive(:env).and_return({'ApplicationInsights.request.id' => '|1234abcd.'})

      get :index, params: {group_id: 'XouN12Ow'}
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    context 'the correct instance variables' do
      it 'assigns @group' do
        expect(assigns(:group)).to be_a(Grom::Node)
        expect(assigns(:group).type).to include('https://id.parliament.uk/schema/Group')
      end
    end

    context 'calling the serializers correctly' do
      it 'calls the Heading1ComponentSerializer correctly' do
        expect(ComponentSerializer::Heading1ComponentSerializer).to have_received(:new).with(heading_content: 'Availability Types', subheading_content: 'groupName - 1', subheading_link: '/groups/XouN12Ow')
      end

      it 'calls the ListPageSerializer correctly' do
        list_components = [{"data" =>
                                {"heading" =>
                                     {"data" =>
                                          {"content" => "groups.subsidiary-resources.layings-title",
                                           "link" =>
                                               "/groups/XouN12Ow/made-available/availability-types/layings",
                                           "size" => 2},
                                      "name" => "heading"}},
                            "name" => "card__generic"}]

        expect(PageSerializer::ListPageSerializer).to have_received(:new).with(request: request, heading_component: heading, list_components: list_components, data_alternates: data_alternates)
      end
    end
  end
end
