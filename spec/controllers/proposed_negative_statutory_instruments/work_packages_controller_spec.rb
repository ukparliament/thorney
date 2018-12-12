require 'rails_helper'

RSpec.describe ProposedNegativeStatutoryInstruments::WorkPackagesController, vcr: true do
  describe 'GET index' do
    let(:data_alternates) do
      [{
         href: "#{ENV['PARLIAMENT_BASE_URL']}/proposed_negative_statutory_instrument_work_packages.nt?proposed_negative_statutory_instrument_id=XQq1bJo0",
         type: 'application/n-triples'
       },
       {href: "#{ENV['PARLIAMENT_BASE_URL']}/proposed_negative_statutory_instrument_work_packages.ttl?proposed_negative_statutory_instrument_id=XQq1bJo0",
        type: 'text/turtle'},
       {href: "#{ENV['PARLIAMENT_BASE_URL']}/proposed_negative_statutory_instrument_work_packages.tsv?proposed_negative_statutory_instrument_id=XQq1bJo0",
        type: 'text/tab-separated-values'},
       {href: "#{ENV['PARLIAMENT_BASE_URL']}/proposed_negative_statutory_instrument_work_packages.csv?proposed_negative_statutory_instrument_id=XQq1bJo0",
        type: 'text/csv'},
       {href: "#{ENV['PARLIAMENT_BASE_URL']}/proposed_negative_statutory_instrument_work_packages.rj?proposed_negative_statutory_instrument_id=XQq1bJo0",
        type: 'application/json+rdf'},
       {href: "#{ENV['PARLIAMENT_BASE_URL']}/proposed_negative_statutory_instrument_work_packages.json?proposed_negative_statutory_instrument_id=XQq1bJo0",
        type: 'application/json+ld'},
       {href: "#{ENV['PARLIAMENT_BASE_URL']}/proposed_negative_statutory_instrument_work_packages.xml?proposed_negative_statutory_instrument_id=XQq1bJo0",
        type: 'application/rdf+xml'}]
    end

    let(:heading) {'a heading component'}

    before(:each) do
      allow(PageSerializer::ListPageSerializer).to receive(:new)
      allow(ComponentSerializer::Heading1ComponentSerializer).to receive(:new) {heading}

      allow(controller.request).to receive(:env).and_return({'ApplicationInsights.request.id' => '|1234abcd.'})

      get :index, params: {proposed_negative_statutory_instrument_id: 'XQq1bJo0'}
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
        expect(ComponentSerializer::Heading1ComponentSerializer).to have_received(:new).with(heading: 'workPackagedThingName - 1 - procedural activity', subheading: 'workPackagedThingName - 1', subheading_link: '/proposed-negative-statutory-instruments/XQq1bJo0')
      end

      it 'calls the ListPageSerializer correctly' do
        list_components = [{"data" =>
                                {"heading" =>
                                     {"data" =>
                                          {"content" => "<a href=\"/work-packages/V5iuO9gU\">workPackagedThingName - 1</a>",
                                           "size" => 2},
                                      "name" => "heading"},
                                 "list-description" =>
                                     {"data" =>
                                          {"items" =>
                                               [{"description"=>[{"content"=>"procedureName - 1"}],
                                                 "term"=>{"content"=>"laid-thing.procedure"}},
                                                 {"description" => [{"content" => "shared.time-html",
                                                                    "data"=>{"date"=>"5 December 2018", "datetime-value"=>"2018-12-05"}}],
                                                 "term" =>
                                                     {"content" =>
                                                          "laid-thing.laid-date"}}]},
                                      "name" => "list__description"}},
                            "name" => "card__generic"}]

        expect(PageSerializer::ListPageSerializer).to have_received(:new).with(request: request, heading_component: heading, list_components: list_components, data_alternates: data_alternates)
      end
    end
  end
end
