require 'rails_helper'

RSpec.describe Groups::MadeAvailable::AvailabilityTypes::LaidPapers::PaperTypesController, vcr: true do
  describe 'GET index' do
    let(:data_alternates) do
      [{
         href: "#{ENV['PARLIAMENT_BASE_URL']}/group_by_id.nt?group_id=XouN12Ow",
         type: 'application/n-triples'
       },
       { href: "#{ENV['PARLIAMENT_BASE_URL']}/group_by_id.ttl?group_id=XouN12Ow",
         type: 'text/turtle' },
       { href: "#{ENV['PARLIAMENT_BASE_URL']}/group_by_id.tsv?group_id=XouN12Ow",
         type: 'text/tab-separated-values' },
       { href: "#{ENV['PARLIAMENT_BASE_URL']}/group_by_id.csv?group_id=XouN12Ow",
         type: 'text/csv' },
       { href: "#{ENV['PARLIAMENT_BASE_URL']}/group_by_id.rj?group_id=XouN12Ow",
         type: 'application/json+rdf' },
       { href: "#{ENV['PARLIAMENT_BASE_URL']}/group_by_id.json?group_id=XouN12Ow",
         type: 'application/json+ld' },
       { href: "#{ENV['PARLIAMENT_BASE_URL']}/group_by_id.xml?group_id=XouN12Ow",
         type: 'application/rdf+xml' }]
    end

    let(:heading) { 'a heading component' }

    before(:each) do
      allow(PageSerializer::ListPageSerializer).to receive(:new)
      allow(ComponentSerializer::Heading1ComponentSerializer).to receive(:new) { heading }

      allow(controller.request).to receive(:env).and_return({ 'ApplicationInsights.request.id' => '|1234abcd.' })

      get :index, params: { group_id: 'XouN12Ow' }
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
        expect(ComponentSerializer::Heading1ComponentSerializer).to have_received(:new).with(heading: 'groupName - 1 - procedural activity by paper type', subheading: 'groupName - 1', subheading_link: '/groups/XouN12Ow')
      end

      it 'calls the ListPageSerializer correctly' do
        list_components =       list_components = [{"data"=>
                                                      {"heading"=>
                                                         {"data"=>
                                                            {"content"=>"<a href=\"/groups/XouN12Ow/made-available/availability-types/laid-papers/paper-types/proposed-negative-statutory-instruments\">Proposed negative statutory instruments</a>",
                                                             "size"=>2},
                                                          "name"=>"heading"}},
                                                    "name"=>"card__generic"},
                                                   {"data"=>
                                                      {"heading"=>
                                                         {"data"=>
                                                            {"content"=>"<a href=\"/groups/XouN12Ow/made-available/availability-types/laid-papers/paper-types/statutory-instruments\">Statutory instruments</a>",
                                                             "size"=>2},
                                                          "name"=>"heading"}},
                                                    "name"=>"card__generic"},
                                                   {"data"=>
                                                      {"heading"=>
                                                         {"data"=>
                                                            {"content"=>"<a href=\"/groups/XouN12Ow/made-available/availability-types/laid-papers/paper-types/treaties\">Treaties</a>",
                                                             "size"=>2},
                                                          "name"=>"heading"}},
                                                    "name"=>"card__generic"}]

        expect(PageSerializer::ListPageSerializer).to have_received(:new).with(request: request, heading_component: heading, list_components: list_components, data_alternates: data_alternates)
      end
    end
  end

  describe 'GET show' do
    let(:data_alternates) do
      [{
         :href => "#{ENV['PARLIAMENT_BASE_URL']}/group_laid_papers_paper_type_statutory_instruments.nt?group_id=XouN12Ow",
         :type => "application/n-triples" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/group_laid_papers_paper_type_statutory_instruments.ttl?group_id=XouN12Ow",
         :type => "text/turtle" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/group_laid_papers_paper_type_statutory_instruments.tsv?group_id=XouN12Ow",
         :type => "text/tab-separated-values" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/group_laid_papers_paper_type_statutory_instruments.csv?group_id=XouN12Ow",
         :type => "text/csv" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/group_laid_papers_paper_type_statutory_instruments.rj?group_id=XouN12Ow",
         :type => "application/json+rdf" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/group_laid_papers_paper_type_statutory_instruments.json?group_id=XouN12Ow",
         :type => "application/json+ld" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/group_laid_papers_paper_type_statutory_instruments.xml?group_id=XouN12Ow",
         :type => "application/rdf+xml" }]
    end

    let(:heading) { 'a heading component' }

    context 'statutory-instruments' do
      before(:each) do
        allow(PageSerializer::ListPageSerializer).to receive(:new)
        allow(ComponentSerializer::Heading1ComponentSerializer).to receive(:new) { heading }

        allow(controller.request).to receive(:env).and_return({'ApplicationInsights.request.id' => '|1234abcd.'})

        get :show, params: { group_id: 'XouN12Ow', paper_type: 'statutory-instruments' }
      end

      it 'should have a response with http status ok (200)' do
        expect(response).to have_http_status(:ok)
      end

      context 'the correct instance variables' do
        it 'assigns @group' do
          expect(assigns(:group)).to be_a(Grom::Node)
          expect(assigns(:group).type).to include('https://id.parliament.uk/schema/Group')
        end

        it 'assigns @laid_things' do
          assigns(:laid_things).each do |laid_thing|
            expect(laid_thing).to be_a(Grom::Node)
            expect(laid_thing.type).to include('https://id.parliament.uk/schema/LaidThing')
          end
        end
      end

      context 'calling the serializers correctly' do
        it 'calls the Heading1ComponentSerializer correctly' do
          expect(ComponentSerializer::Heading1ComponentSerializer).to have_received(:new).with(heading: 'groupName - 1 - procedural activity for statutory instruments', subheading: 'groupName - 1', subheading_link: '/groups/XouN12Ow')
        end

        it 'calls the ListPageSerializer correctly' do
          list_components = [{"data"=>
                                {"heading"=>
                                   {"data"=>
                                      {"content"=>"<a href=\"/statutory-instruments/xic2yu5i\">laidThingName - 1</a>",
                                       "size"=>2},
                                    "name"=>"heading"},
                                 "list-description"=>
                                   {"data"=>{"items"=>[{"description"=>[{"content"=>"shared.time-html", "data"=>{"date"=>"20 April 2018", "datetime-value"=>"2018-04-20"}}], "term"=>{"content"=>"laid-thing.laid-date"}}, {"description"=>[{"content"=>"procedureName - 1"}],
                                                        "term"=>{"content"=>"laid-thing.procedure"}}]}, "name"=>"list__description"}}, "name"=>"card__generic"}]

          expect(PageSerializer::ListPageSerializer).to have_received(:new).with(request: request, heading_component: heading, list_components: list_components, data_alternates: data_alternates)
        end
      end

      it 'makes a request to the correct data endpoint' do
        expect(assigns(:api_request).query_url).to eq("#{ENV['PARLIAMENT_BASE_URL']}/group_laid_papers_paper_type_statutory_instruments?group_id=XouN12Ow")
      end
    end

    context 'proposed-negative-statutory-instruments' do
      before(:each) do
        allow(PageSerializer::ListPageSerializer).to receive(:new)
        allow(ComponentSerializer::Heading1ComponentSerializer).to receive(:new) { heading }

        allow(controller.request).to receive(:env).and_return({'ApplicationInsights.request.id' => '|1234abcd.'})

        get :show, params: { group_id: 'XouN12Ow', paper_type: 'proposed-negative-statutory-instruments' }
      end

      it 'calls the Heading1ComponentSerializer correctly' do
        expect(ComponentSerializer::Heading1ComponentSerializer).to have_received(:new).with(heading: 'groupName - 1 - procedural activity for proposed negative statutory instruments', subheading: 'groupName - 1', subheading_link: '/groups/XouN12Ow')
      end

      it 'makes a request to the correct data endpoint for proposed-negative-statutory-instruments' do
        expect(assigns(:api_request).query_url).to eq("#{ENV['PARLIAMENT_BASE_URL']}/group_laid_papers_paper_type_proposed_negative_statutory_instruments?group_id=XouN12Ow")
      end
    end

    context 'treaties' do
      before(:each) do
        allow(PageSerializer::ListPageSerializer).to receive(:new)
        allow(ComponentSerializer::Heading1ComponentSerializer).to receive(:new) { heading }

        allow(controller.request).to receive(:env).and_return({'ApplicationInsights.request.id' => '|1234abcd.'})

        get :show, params: { group_id: 'XouN12Ow', paper_type: 'treaties' }
      end

      it 'calls the Heading1ComponentSerializer correctly' do
        expect(ComponentSerializer::Heading1ComponentSerializer).to have_received(:new).with(heading: 'groupName - 1 - procedural activity for treaties', subheading: 'groupName - 1', subheading_link: '/groups/XouN12Ow')
      end

      it 'makes a request to the correct data endpoint for treaties' do
        expect(assigns(:api_request).query_url).to eq("#{ENV['PARLIAMENT_BASE_URL']}/group_laid_papers_paper_type_treaties?group_id=XouN12Ow")
      end
    end
  end
end
