require 'rails_helper'

RSpec.describe Houses::MadeAvailable::AvailabilityTypesController, vcr: true do
  describe 'GET index' do
    let(:data_alternates) do
      [{
         href: "#{ENV['PARLIAMENT_BASE_URL']}/house_by_id.nt?house_id=WkUWUBMx",
         type: 'application/n-triples'
       },
       {href: "#{ENV['PARLIAMENT_BASE_URL']}/house_by_id.ttl?house_id=WkUWUBMx",
        type: 'text/turtle'},
       {href: "#{ENV['PARLIAMENT_BASE_URL']}/house_by_id.tsv?house_id=WkUWUBMx",
        type: 'text/tab-separated-values'},
       {href: "#{ENV['PARLIAMENT_BASE_URL']}/house_by_id.csv?house_id=WkUWUBMx",
        type: 'text/csv'},
       {href: "#{ENV['PARLIAMENT_BASE_URL']}/house_by_id.rj?house_id=WkUWUBMx",
        type: 'application/json+rdf'},
       {href: "#{ENV['PARLIAMENT_BASE_URL']}/house_by_id.json?house_id=WkUWUBMx",
        type: 'application/json+ld'},
       {href: "#{ENV['PARLIAMENT_BASE_URL']}/house_by_id.xml?house_id=WkUWUBMx",
        type: 'application/rdf+xml'}]
    end

    let(:heading) {'a heading component'}

    before(:each) do
      allow(PageSerializer::ListPageSerializer).to receive(:new)
      allow(ComponentSerializer::Heading1ComponentSerializer).to receive(:new) {heading}

      allow(controller.request).to receive(:env).and_return({'ApplicationInsights.request.id' => '|1234abcd.'})

      get :index, params: { house_id: 'WkUWUBMx' }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    context 'the correct instance variables' do
      it 'assigns @house' do
        expect(assigns(:house)).to be_a(Grom::Node)
        expect(assigns(:house).type).to include('https://id.parliament.uk/schema/House')
      end
    end

    context 'calling the serializers correctly' do
      it 'calls the Heading1ComponentSerializer correctly' do
        expect(ComponentSerializer::Heading1ComponentSerializer).to have_received(:new).with(heading: 'houseName - 1 - made available by availability types', subheading: 'houseName - 1', subheading_link: '/houses/WkUWUBMx')
      end

      it 'calls the ListPageSerializer correctly' do
        list_components = [{"data" =>
                              {"heading" =>
                                 {"data" =>
                                    {"content" => "houses.subsidiary-resources.laid-papers",
                                     "data"=> {"link"=>"/houses/WkUWUBMx/made-available/availability-types/laid-papers"},
                                     "size" => 2},
                                  "name" => "heading"}},
                            "name" => "card__generic"}]

        expect(PageSerializer::ListPageSerializer).to have_received(:new).with(request: request, heading_component: heading, list_components: list_components, data_alternates: data_alternates)
      end
    end
  end
end
