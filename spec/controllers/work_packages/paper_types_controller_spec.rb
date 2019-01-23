# -*- coding: utf-8 -*-
require 'rails_helper'

RSpec.describe WorkPackages::PaperTypesController, vcr: true do
  describe 'GET index' do
    let(:heading) { 'a heading component' }

    before(:each) do
      allow(PageSerializer::ListPageSerializer).to receive(:new)
      allow(ComponentSerializer::Heading1ComponentSerializer).to receive(:new).with(heading: 'Procedural activity by paper type') { heading }

      allow(controller.request).to receive(:env).and_return({'ApplicationInsights.request.id' => '|1234abcd.'})

      get :index
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'calls the serializer correctly' do
      list_components = [{"data"=>
                            {"heading"=>
                               {"data"=>
                                  {"content"=>"<a href=\"/work-packages/paper-types/proposed-negative-statutory-instruments\">Proposed negative statutory instruments</a>",
                                   "size"=>2},
                                "name"=>"heading"}},
                           "name"=>"card__generic"},
                         {"data"=>
                           {"heading"=>
                              {"data"=>
                                 {"content"=>"<a href=\"/work-packages/paper-types/statutory-instruments\">Statutory instruments</a>",
                                  "size"=>2},
                               "name"=>"heading"}},
                         "name"=>"card__generic"},
                         {"data"=>
                            {"heading"=>
                               {"data"=>
                                  {"content"=>"<a href=\"/work-packages/paper-types/treaties\">Treaties</a>",
                                   "size"=>2},
                                "name"=>"heading"}},
                          "name"=>"card__generic"}]

      expect(PageSerializer::ListPageSerializer).to have_received(:new).with(request: request, heading_component: heading, list_components: list_components)
    end
  end

  describe 'GET show' do
    let(:data_alternates) do
      [{
         :href => "#{ENV['PARLIAMENT_BASE_URL']}/work_packages_paper_types_statutory_instruments.nt",
         :type => "application/n-triples" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/work_packages_paper_types_statutory_instruments.ttl",
         :type => "text/turtle" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/work_packages_paper_types_statutory_instruments.tsv",
         :type => "text/tab-separated-values" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/work_packages_paper_types_statutory_instruments.csv",
         :type => "text/csv" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/work_packages_paper_types_statutory_instruments.rj",
         :type => "application/json+rdf" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/work_packages_paper_types_statutory_instruments.json",
         :type => "application/json+ld" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/work_packages_paper_types_statutory_instruments.xml",
         :type => "application/rdf+xml" }]
    end

    let(:heading) { 'a heading component' }

    context 'statutory-instruments' do
      before(:each) do
        allow(PageSerializer::ListPageSerializer).to receive(:new)
        allow(ComponentSerializer::Heading1ComponentSerializer).to receive(:new).with(heading: 'Procedural activity for statutory instruments') { heading }

        allow(controller.request).to receive(:env).and_return({'ApplicationInsights.request.id' => '|1234abcd.'})

        get :show, params: { paper_type: 'statutory-instruments' }
      end

      it 'should have a response with http status ok (200)' do
        expect(response).to have_http_status(:ok)
      end

      it 'assigns @work_packages' do
        assigns(:work_packages).each do |work_package|
          expect(work_package).to be_a(Grom::Node)
          expect(work_package.type).to include('https://id.parliament.uk/schema/WorkPackage')
        end
      end

      it 'calls the serializer correctly' do
        list_components = [{"data"=>
                              {"heading"=>
                                 {"data"=>
                                    {"content"=>"<a href=\"/work-packages/rlJaCEwJ\">workPackagedThingName - 1</a>",
                                     "size"=>2},
                                  "name"=>"heading"},
                               "list-description"=>
                                 {"data"=>{"items"=>[{"description"=>[{"content"=>"procedureName - 1"}],
                                                      "term"=>{"content"=>"laid-thing.procedure"}}, {"description"=>[{"content"=>"shared.time-html", "data"=>{"date"=>"23 April 2018", "datetime-value"=>"2018-04-23"}}], "term"=>{"content"=>"laid-thing.laid-date"}}]}, "name"=>"list__description"}}, "name"=>"card__generic"}]

        expect(PageSerializer::ListPageSerializer).to have_received(:new).with(request: request, heading_component: heading, list_components: list_components, data_alternates: data_alternates)
      end

      it 'makes a request to the correct data endpoint' do
        expect(assigns(:api_request).query_url).to eq("#{ENV['PARLIAMENT_BASE_URL']}/work_packages_paper_types_statutory_instruments")
      end
    end

    context 'proposed-negative-statutory-instruments' do
      before(:each) do
        allow(PageSerializer::ListPageSerializer).to receive(:new)
        allow(ComponentSerializer::Heading1ComponentSerializer).to receive(:new).with(heading: 'Procedural activity for proposed negative statutory instruments') { heading }

        allow(controller.request).to receive(:env).and_return({'ApplicationInsights.request.id' => '|1234abcd.'})

        get :show, params: { paper_type: 'proposed-negative-statutory-instruments' }
      end

      it 'makes a request to the correct data endpoint for proposed-negative-statutory-instruments' do
        expect(assigns(:api_request).query_url).to eq("#{ENV['PARLIAMENT_BASE_URL']}/work_packages_paper_types_proposed_negative_statutory_instruments")
      end
    end

    context 'treaties' do
      before(:each) do
        allow(PageSerializer::ListPageSerializer).to receive(:new)
        allow(ComponentSerializer::Heading1ComponentSerializer).to receive(:new).with(heading: 'Procedural activity for treaties') { heading }

        allow(controller.request).to receive(:env).and_return({'ApplicationInsights.request.id' => '|1234abcd.'})

        get :show, params: { paper_type: 'treaties' }
      end

      it 'makes a request to the correct data endpoint for treaties' do
        expect(assigns(:api_request).query_url).to eq("#{ENV['PARLIAMENT_BASE_URL']}/work_packages_paper_types_treaties")
      end
    end
  end

  describe 'GET current' do
    let(:data_alternates) do
      [{
         :href => "#{ENV['PARLIAMENT_BASE_URL']}/work_packages_paper_types_statutory_instruments_current.nt",
         :type => "application/n-triples" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/work_packages_paper_types_statutory_instruments_current.ttl",
         :type => "text/turtle" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/work_packages_paper_types_statutory_instruments_current.tsv",
         :type => "text/tab-separated-values" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/work_packages_paper_types_statutory_instruments_current.csv",
         :type => "text/csv" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/work_packages_paper_types_statutory_instruments_current.rj",
         :type => "application/json+rdf" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/work_packages_paper_types_statutory_instruments_current.json",
         :type => "application/json+ld" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/work_packages_paper_types_statutory_instruments_current.xml",
         :type => "application/rdf+xml" }]
    end

    let(:heading) { 'a heading component' }

    context 'statutory-instruments' do
      before(:each) do
        allow(PageSerializer::ListPageSerializer).to receive(:new)
        allow(ComponentSerializer::Heading1ComponentSerializer).to receive(:new).with(heading: 'Current procedural activity for statutory instruments') { heading }

        allow(controller.request).to receive(:env).and_return({'ApplicationInsights.request.id' => '|1234abcd.'})

        get :current, params: { paper_type: 'statutory-instruments' }
      end

      it 'should have a response with http status ok (200)' do
        expect(response).to have_http_status(:ok)
      end

      it 'assigns @work_packages' do
        assigns(:work_packages).each do |work_package|
          expect(work_package).to be_a(Grom::Node)
          expect(work_package.type).to include('https://id.parliament.uk/schema/WorkPackage')
        end
      end

      it 'calls the serializer correctly' do
        list_components = [{"data"=>
                              {"heading"=>
                                 {"data"=>
                                    {"content"=>"<a href=\"/work-packages/rlJaCEwJ\">workPackagedThingName - 1</a>",
                                     "size"=>2},
                                  "name"=>"heading"},
                               "list-description"=>
                                 {"data"=>{"items"=>[{"description"=>[{"content"=>"procedureName - 1"}],
                                                      "term"=>{"content"=>"laid-thing.procedure"}}, {"description"=>[{"content"=>"shared.time-html", "data"=>{"date"=>"23 April 2018", "datetime-value"=>"2018-04-23"}}], "term"=>{"content"=>"laid-thing.laid-date"}}]}, "name"=>"list__description"}}, "name"=>"card__generic"}]

        expect(PageSerializer::ListPageSerializer).to have_received(:new).with(request: request, heading_component: heading, list_components: list_components, data_alternates: data_alternates)
      end

      it 'makes a request to the correct data endpoint' do
        expect(assigns(:api_request).query_url).to eq("#{ENV['PARLIAMENT_BASE_URL']}/work_packages_paper_types_statutory_instruments_current")
      end
    end

    context 'proposed-negative-statutory-instruments' do
      before(:each) do
        allow(PageSerializer::ListPageSerializer).to receive(:new)
        allow(ComponentSerializer::Heading1ComponentSerializer).to receive(:new).with(heading: 'Current procedural activity for proposed negative statutory instruments') { heading }

        allow(controller.request).to receive(:env).and_return({'ApplicationInsights.request.id' => '|1234abcd.'})

        get :current, params: { paper_type: 'proposed-negative-statutory-instruments' }
      end

      it 'makes a request to the correct data endpoint for proposed-negative-statutory-instruments' do
        expect(assigns(:api_request).query_url).to eq("#{ENV['PARLIAMENT_BASE_URL']}/work_packages_paper_types_proposed_negative_statutory_instruments_current")
      end
    end
  end
end
