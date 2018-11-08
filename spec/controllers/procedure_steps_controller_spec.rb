# -*- coding: utf-8 -*-
require 'rails_helper'

RSpec.describe ProcedureStepsController, vcr: true do
  describe 'GET index' do
    let(:data_alternates) do
      [{
           :href => "#{ENV['PARLIAMENT_BASE_URL']}/procedure_step_index.nt",
           :type => "application/n-triples" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/procedure_step_index.ttl",
         :type => "text/turtle" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/procedure_step_index.tsv",
         :type => "text/tab-separated-values" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/procedure_step_index.csv",
         :type => "text/csv" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/procedure_step_index.rj",
         :type => "application/json+rdf" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/procedure_step_index.json",
         :type => "application/json+ld" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/procedure_step_index.xml",
         :type => "application/rdf+xml" }]
    end

    let(:heading) { 'a heading component' }

    before(:each) do
      allow(PageSerializer::ListPageSerializer).to receive(:new)
      allow(ComponentSerializer::Heading1ComponentSerializer).to receive(:new).with(heading: 'Procedure steps') { heading }

      allow(controller.request).to receive(:env).and_return({'ApplicationInsights.request.id' => '|1234abcd.'})

      get :index
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @procedure_steps' do
      assigns(:procedure_steps).each do |procedure_step|
        expect(procedure_step).to be_a(Grom::Node)
        expect(procedure_step.type).to include('https://id.parliament.uk/schema/ProcedureStep')
      end
    end

    it 'calls the serializer correctly' do
      list_components = [{"data" =>
                              {"heading" =>
                                   {"data" =>
                                        {"content" => "procedureStepName - 1",
                                         "link" => "/procedure-steps/e9G2vHbc",
                                         "size" => 2},
                                    "name" => "heading"}},
                          "name" => "card__generic"},
                         {"data" =>
                              {"heading" =>
                                   {"data" =>
                                        {"content" => "procedureStepName - 85",
                                         "link" => "/procedure-steps/2J36nNXG",
                                         "size" => 2},
                                    "name" => "heading"},
                               "paragraph" =>
                                   {"data" => [{"content" => "procedureStepDescription - 1"}],
                                    "name" => "paragraph"}},
                          "name" => "card__generic"}]

      expect(PageSerializer::ListPageSerializer).to have_received(:new).with(request: request, heading_component: heading, list_components: list_components, data_alternates: data_alternates)
    end

    context 'if a house does not have a name' do
      it 'can handle the nils' do
        expect(PageSerializer::ListPageSerializer).to have_received(:new)
      end
    end
  end

  describe 'GET show' do
    let(:data_alternates) do
      [{
           :href => "#{ENV['PARLIAMENT_BASE_URL']}/procedure_step_by_id.nt?procedure_step_id=12345678",
           :type => "application/n-triples" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/procedure_step_by_id.ttl?procedure_step_id=12345678",
         :type => "text/turtle" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/procedure_step_by_id.tsv?procedure_step_id=12345678",
         :type => "text/tab-separated-values" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/procedure_step_by_id.csv?procedure_step_id=12345678",
         :type => "text/csv" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/procedure_step_by_id.rj?procedure_step_id=12345678",
         :type => "application/json+rdf" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/procedure_step_by_id.json?procedure_step_id=12345678",
         :type => "application/json+ld" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/procedure_step_by_id.xml?procedure_step_id=12345678",
         :type => "application/rdf+xml" }]
    end

    before(:each) do
      allow(PageSerializer::ProcedureStepsShowPageSerializer).to receive(:new)
      allow(controller.request).to receive(:env).and_return({'ApplicationInsights.request.id' => '|1234abcd.'})

      get :show, params: { procedure_step_id: 12345678 }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @procedure_step' do
      expect(assigns(:procedure_step)).to be_a(Grom::Node)
      expect(assigns(:procedure_step).type).to include('https://id.parliament.uk/schema/ProcedureStep')
    end

    it 'calls the serializer correctly' do
      procedure_step = assigns(:procedure_step)

      expect(PageSerializer::ProcedureStepsShowPageSerializer).to have_received(:new).with(request: request, procedure_step: procedure_step, data_alternates: data_alternates)
    end
  end
end
