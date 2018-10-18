# -*- coding: utf-8 -*-
require 'rails_helper'

RSpec.describe StatutoryInstrumentsController, vcr: true do
  describe 'GET index' do
    let(:data_alternates) do
      [{
         :href => "#{ENV['PARLIAMENT_BASE_URL']}/statutory_instrument_index.nt",
         :type => "application/n-triples" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/statutory_instrument_index.ttl",
         :type => "text/turtle" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/statutory_instrument_index.tsv",
         :type => "text/tab-separated-values" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/statutory_instrument_index.csv",
         :type => "text/csv" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/statutory_instrument_index.rj",
         :type => "application/json+rdf" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/statutory_instrument_index.json",
         :type => "application/json+ld" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/statutory_instrument_index.xml",
         :type => "application/rdf+xml" }]
    end

    let(:heading) { 'a heading component' }

    before(:each) do
      allow(PageSerializer::ListPageSerializer).to receive(:new)
      allow(ComponentSerializer::Heading1ComponentSerializer).to receive(:new).with(heading_content: 'Statutory Instruments') { heading }

      allow(controller.request).to receive(:env).and_return({'ApplicationInsights.request.id' => '|1234abcd.'})

      get :index
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @statutory_instruments' do
      assigns(:statutory_instruments).each do |statutory_instrument|
        expect(statutory_instrument).to be_a(Grom::Node)
        expect(statutory_instrument.type).to include('https://id.parliament.uk/schema/StatutoryInstrumentPaper')
      end
    end

    it 'calls the serializer correctly' do
      list_components = [{"data"=>
                            {"heading"=>
                               {"data"=>
                                  {"content"=>"statutoryInstrumentPaperName - 1",
                                   "link"=>"/statutory-instruments/5trFJNih",
                                   "size"=>2},
                                "name"=>"heading"},
                             "list-description"=>
                               {"data"=>{"items"=>[{"description"=>[{"content"=>"shared.time-html", "data"=>{"date"=>"23 April 2018", "datetime-value"=>"2018-04-23"}}], "term"=>{"content"=>"laid-thing.laid-date"}}, {"description"=>[{"content"=>"groupName - 1"}],"term"=>{"content"=>"laid-thing.laying-body"}}, {"description"=>[{"content"=>"procedureName - 1"}], "term"=>{"content"=>"laid-thing.procedure"}}]}, "name"=>"list__description"}}, "name"=>"card__generic"}]

      expect(PageSerializer::ListPageSerializer).to have_received(:new).with(request: request, heading_component: heading, list_components: list_components, data_alternates: data_alternates)
    end
  end

  describe 'GET show' do
    let(:data_alternates) do
      [{
         :href => "#{ENV['PARLIAMENT_BASE_URL']}/statutory_instrument_by_id.nt?statutory_instrument_id=12345678",
         :type => "application/n-triples" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/statutory_instrument_by_id.ttl?statutory_instrument_id=12345678",
         :type => "text/turtle" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/statutory_instrument_by_id.tsv?statutory_instrument_id=12345678",
         :type => "text/tab-separated-values" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/statutory_instrument_by_id.csv?statutory_instrument_id=12345678",
         :type => "text/csv" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/statutory_instrument_by_id.rj?statutory_instrument_id=12345678",
         :type => "application/json+rdf" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/statutory_instrument_by_id.json?statutory_instrument_id=12345678",
         :type => "application/json+ld" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/statutory_instrument_by_id.xml?statutory_instrument_id=12345678",
         :type => "application/rdf+xml" }]
    end

    before(:each) do
      allow(PageSerializer::StatutoryInstrumentsShowPageSerializer).to receive(:new)
      allow(controller.request).to receive(:env).and_return({'ApplicationInsights.request.id' => '|1234abcd.'})

      get :show, params: { statutory_instrument_id: 12345678 }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @statutory_instrument' do
      expect(assigns(:statutory_instrument)).to be_a(Grom::Node)
      expect(assigns(:statutory_instrument).type).to include('https://id.parliament.uk/schema/StatutoryInstrumentPaper')
    end

    it 'calls the serializer correctly' do
      statutory_instrument = assigns(:statutory_instrument)

      expect(PageSerializer::StatutoryInstrumentsShowPageSerializer).to have_received(:new).with(request: request, statutory_instrument: statutory_instrument, data_alternates: data_alternates)
    end
  end
end
