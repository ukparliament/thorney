# -*- coding: utf-8 -*-
require 'rails_helper'

RSpec.describe Procedures::WorkPackagesController, vcr: true do
  describe 'GET index' do
    let(:data_alternates) do
      [{
         :href => "#{ENV['PARLIAMENT_BASE_URL']}/procedure_work_packages.nt?procedure_id=12345678",
         :type => "application/n-triples" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/procedure_work_packages.ttl?procedure_id=12345678",
         :type => "text/turtle" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/procedure_work_packages.tsv?procedure_id=12345678",
         :type => "text/tab-separated-values" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/procedure_work_packages.csv?procedure_id=12345678",
         :type => "text/csv" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/procedure_work_packages.rj?procedure_id=12345678",
         :type => "application/json+rdf" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/procedure_work_packages.json?procedure_id=12345678",
         :type => "application/json+ld" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/procedure_work_packages.xml?procedure_id=12345678",
         :type => "application/rdf+xml" }]
    end

    let(:heading) {'a heading component'}

    before(:each) do
      allow(PageSerializer::ListPageSerializer).to receive(:new)
      allow(ComponentSerializer::Heading1ComponentSerializer).to receive(:new).with(heading: 'procedureName - 1 - procedural activity', subheading: 'procedureName - 1', subheading_link: '/procedures/12345678') { heading }

      allow(controller.request).to receive(:env).and_return({ 'ApplicationInsights.request.id' => '|1234abcd.' })

      get :index, params: { procedure_id: 12345678 }
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
      list_components = [{ "data"                                                                                                                                                                                                                                                                 =>
                             { "heading"          =>
                                 { "data" =>
                                     { "content" => "workPackagedThingName - 1",
                                       "link"    => "/work-packages/zlDxL3xS",
                                       "size"    => 2 },
                                   "name" => "heading" },
                               "list-description" =>
                                 { "data" => { "items" => [nil, { "description" => [{ "content" => "shared.time-html", "data" => { "date" => "16 April 2018", "datetime-value" => "2018-04-16" } }], "term" => { "content" => "laid-thing.laid-date" } }] }, "name" => "list__description" } }, "name" => "card__generic" }]

      expect(PageSerializer::ListPageSerializer).to have_received(:new).with(request: request, heading_component: heading, list_components: list_components, data_alternates: data_alternates)
    end
  end

  describe 'GET current' do
    let(:data_alternates) do
      [{
         :href => "#{ENV['PARLIAMENT_BASE_URL']}/procedure_work_packages_current.nt?procedure_id=12345678",
         :type => "application/n-triples" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/procedure_work_packages_current.ttl?procedure_id=12345678",
         :type => "text/turtle" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/procedure_work_packages_current.tsv?procedure_id=12345678",
         :type => "text/tab-separated-values" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/procedure_work_packages_current.csv?procedure_id=12345678",
         :type => "text/csv" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/procedure_work_packages_current.rj?procedure_id=12345678",
         :type => "application/json+rdf" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/procedure_work_packages_current.json?procedure_id=12345678",
         :type => "application/json+ld" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/procedure_work_packages_current.xml?procedure_id=12345678",
         :type => "application/rdf+xml" }]
    end

    let(:heading) {'a heading component'}

    before(:each) do
      allow(PageSerializer::ListPageSerializer).to receive(:new)
      allow(ComponentSerializer::Heading1ComponentSerializer).to receive(:new).with(heading: 'procedureName - 1 - current procedural activity', subheading: 'procedureName - 1', subheading_link: '/procedures/12345678') { heading }

      allow(controller.request).to receive(:env).and_return({ 'ApplicationInsights.request.id' => '|1234abcd.' })

      get :current, params: { procedure_id: 12345678 }
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
      list_components = [{ "data"                                                                                                                                                                                                                                                                                                                               =>
                             { "heading"          =>
                                 { "data" =>
                                     { "content" => "workPackagedThingName - 1",
                                       "link"    => "/work-packages/zlDxL3xS",
                                       "size"    => 2 },
                                   "name" => "heading" },
                               "list-description" =>
                                 { "data" => { "items" => [nil, { "description" => [{ "content" => "shared.time-html", "data" => { "date" => "16 April 2018", "datetime-value" => "2018-04-16" } }], "term" => { "content" => "laid-thing.laid-date" } }] }, "name" => "list__description" } }, "name" => "card__generic" }]

      expect(PageSerializer::ListPageSerializer).to have_received(:new).with(request: request, heading_component: heading, list_components: list_components, data_alternates: data_alternates)
    end
  end
end
