require 'rails_helper'

RSpec.describe Treaties::WorkPackagesController, vcr: true do
  describe 'GET index' do
    let(:data_alternates) do
      [{
         href: "#{ENV['PARLIAMENT_BASE_URL']}/treaty_work_packages.nt?treaty_id=gzoa2qc8",
         type: 'application/n-triples'
       },
       {href: "#{ENV['PARLIAMENT_BASE_URL']}/treaty_work_packages.ttl?treaty_id=gzoa2qc8",
        type: 'text/turtle'},
       {href: "#{ENV['PARLIAMENT_BASE_URL']}/treaty_work_packages.tsv?treaty_id=gzoa2qc8",
        type: 'text/tab-separated-values'},
       {href: "#{ENV['PARLIAMENT_BASE_URL']}/treaty_work_packages.csv?treaty_id=gzoa2qc8",
        type: 'text/csv'},
       {href: "#{ENV['PARLIAMENT_BASE_URL']}/treaty_work_packages.rj?treaty_id=gzoa2qc8",
        type: 'application/json+rdf'},
       {href: "#{ENV['PARLIAMENT_BASE_URL']}/treaty_work_packages.json?treaty_id=gzoa2qc8",
        type: 'application/json+ld'},
       {href: "#{ENV['PARLIAMENT_BASE_URL']}/treaty_work_packages.xml?treaty_id=gzoa2qc8",
        type: 'application/rdf+xml'}]
    end

    let(:heading) { 'a heading component' }

    before(:each) do
      allow(PageSerializer::ListPageSerializer).to receive(:new)
      allow(ComponentSerializer::Heading1ComponentSerializer).to receive(:new) { heading }

      allow(controller.request).to receive(:env).and_return({ 'ApplicationInsights.request.id' => '|1234abcd.' })

      get :index, params: { treaty_id: 'gzoa2qc8' }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    context 'the correct instance variables' do
      it 'assigns @work_packaged_thing' do
        expect(assigns(:work_packaged_thing)).to be_a(Grom::Node)
        expect(assigns(:work_packaged_thing).type).to include('https://id.parliament.uk/schema/WorkPackagedThing')
      end

      it 'assigns @work_packages' do
        assigns(:work_packages).each do |work_package|
          expect(work_package).to be_a(Grom::Node)
          expect(work_package.type).to include('https://id.parliament.uk/schema/WorkPackage')
        end
      end
    end

    context 'calling the serializers correctly' do
      it 'calls the Heading1ComponentSerializer correctly' do
        expect(ComponentSerializer::Heading1ComponentSerializer).to have_received(:new).with(heading: 'workPackagedThingName - 1 - procedural activity', subheading: 'workPackagedThingName - 1', subheading_link: '/treaties/gzoa2qc8')
      end

      it 'calls the ListPageSerializer correctly' do
        list_components = [{"data" =>
                              {"heading" =>
                                 {"data" =>
                                    {"content" => "<a href=\"/work-packages/3zG07MC9\">workPackagedThingName - 1</a>",
                                     "size" => 2},
                                  "name" => "heading"},
                               "list-description" =>
                                 {"data" =>
                                    {"items" =>
                                       [{"description"=>[{"content"=>"procedureName - 1"}],
                                         "term"=>{"content"=>"laid-thing.procedure"}}, nil]},
                                  "name" => "list__description"}},
                            "name" => "card__generic"}]

        expect(PageSerializer::ListPageSerializer).to have_received(:new).with(request: request, heading_component: heading, list_components: list_components, data_alternates: data_alternates)
      end
    end
  end
end
