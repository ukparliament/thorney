# -*- coding: utf-8 -*-
require 'rails_helper'

RSpec.describe ProceduresController, vcr: true do
  describe 'GET index' do
    let(:data_alternates) do
      [{
         :href => "#{ENV['PARLIAMENT_BASE_URL']}/procedure_index.nt",
         :type => "application/n-triples" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/procedure_index.ttl",
         :type => "text/turtle" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/procedure_index.tsv",
         :type => "text/tab-separated-values" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/procedure_index.csv",
         :type => "text/csv" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/procedure_index.rj",
         :type => "application/json+rdf" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/procedure_index.json",
         :type => "application/json+ld" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/procedure_index.xml",
         :type => "application/rdf+xml" }]
    end

    let(:heading) { 'a heading component' }

    before(:each) do
      allow(PageSerializer::ListPageSerializer).to receive(:new)
      allow(ComponentSerializer::Heading1ComponentSerializer).to receive(:new).with(heading: 'Procedures') { heading }

      allow(controller.request).to receive(:env).and_return({'ApplicationInsights.request.id' => '|1234abcd.'})

      get :index
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @procedures' do
      assigns(:procedures).each do |procedure|
        expect(procedure).to be_a(Grom::Node)
        expect(procedure.type).to include('https://id.parliament.uk/schema/Procedure')
      end
    end

    it 'calls the serializer correctly' do
      list_components = [{"data" =>
                            {"heading" =>
                               {"data" =>
                                  {"content" => "<a href=\"/procedures/5S6p4YsP\">procedureName - 1</a>",
                                   "size" => 2},
                                "name" => "heading"}},
                          "name" => "card__generic"},
                         {"data" =>
                            {"heading" =>
                               {"data" =>
                                  {"content" => "<a href=\"/procedures/H5YJQsK2\">procedureName - 2</a>",
                                   "size" => 2},
                                "name" => "heading"}},
                          "name" => "card__generic"},
                         {"data" =>
                            {"heading" =>
                               {"data" =>
                                  {"content" => "<a href=\"/procedures/gTgidljI\">procedureName - 3</a>",
                                   "size" => 2},
                                "name" => "heading"}},
                          "name" => "card__generic"},
                         {"data" =>
                            {"heading" =>
                               {"data" =>
                                  {"content" => "<a href=\"/procedures/iCdMN1MW\">procedureName - 4</a>",
                                   "size" => 2},
                                "name" => "heading"}},
                          "name" => "card__generic"},
                         {"data" =>
                            {"heading" =>
                               {"data" =>
                                  {"content" => "<a href=\"/procedures/iWugpxMn\">procedureName - 5</a>",
                                   "size" => 2},
                                "name" => "heading"}},
                          "name" => "card__generic"}]

      expect(PageSerializer::ListPageSerializer).to have_received(:new).with(request: request, heading_component: heading, list_components: list_components, data_alternates: data_alternates)
    end
  end

  describe 'GET show' do
    let(:data_alternates) do
      [{
         :href => "#{ENV['PARLIAMENT_BASE_URL']}/procedure_by_id.nt?procedure_id=H5YJQsK2",
         :type => "application/n-triples" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/procedure_by_id.ttl?procedure_id=H5YJQsK2",
         :type => "text/turtle" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/procedure_by_id.tsv?procedure_id=H5YJQsK2",
         :type => "text/tab-separated-values" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/procedure_by_id.csv?procedure_id=H5YJQsK2",
         :type => "text/csv" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/procedure_by_id.rj?procedure_id=H5YJQsK2",
         :type => "application/json+rdf" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/procedure_by_id.json?procedure_id=H5YJQsK2",
         :type => "application/json+ld" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/procedure_by_id.xml?procedure_id=H5YJQsK2",
         :type => "application/rdf+xml" }]
    end

    before(:each) do
      allow(PageSerializer::ProceduresShowPageSerializer).to receive(:new)
      allow(controller.request).to receive(:env).and_return({'ApplicationInsights.request.id' => '|1234abcd.'})

      get :show, params: { procedure_id: 'H5YJQsK2' }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @procedure' do
      expect(assigns(:procedure)).to be_a(Grom::Node)
      expect(assigns(:procedure).type).to include('https://id.parliament.uk/schema/Procedure')
    end

    it 'calls the serializer correctly' do
      procedure = assigns(:procedure)

      expect(PageSerializer::ProceduresShowPageSerializer).to have_received(:new).with(request: request, procedure: procedure, data_alternates: data_alternates)
    end
  end
end
