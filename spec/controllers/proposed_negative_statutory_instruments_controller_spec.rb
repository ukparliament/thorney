# -*- coding: utf-8 -*-
require 'rails_helper'

RSpec.describe ProposedNegativeStatutoryInstrumentsController, vcr: true do
  describe 'GET index' do
    let(:data_alternates) do
      [{
         :href => "#{ENV['PARLIAMENT_BASE_URL']}/proposed_negative_statutory_instrument_index.nt",
         :type => "application/n-triples" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/proposed_negative_statutory_instrument_index.ttl",
         :type => "text/turtle" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/proposed_negative_statutory_instrument_index.tsv",
         :type => "text/tab-separated-values" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/proposed_negative_statutory_instrument_index.csv",
         :type => "text/csv" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/proposed_negative_statutory_instrument_index.rj",
         :type => "application/json+rdf" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/proposed_negative_statutory_instrument_index.json",
         :type => "application/json+ld" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/proposed_negative_statutory_instrument_index.xml",
         :type => "application/rdf+xml" }]
    end

    before(:each) do
      allow(PageSerializer::ListPageSerializer).to receive(:new)
      allow(controller.request).to receive(:env).and_return({'ApplicationInsights.request.id' => '|1234abcd.'})

      get :index
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @proposed_negativestatutory_instruments' do
      assigns(:proposed_negative_statutory_instruments).each do |statutory_instrument|
        expect(statutory_instrument).to be_a(Grom::Node)
        expect(statutory_instrument.type).to include('https://id.parliament.uk/schema/ProposedNegativeStatutoryInstrumentPaper')
      end
    end

    it 'calls the serializer correctly' do
      list_components = [{"data"=> {"heading"=> {"data"=> {"content"=>"proposedNegativeStatutoryInstrumentPaperName - 1", "link"=>"/proposed-negative-statutory-instruments/Tn1xqHc0", "size"=>2}, "name"=>"heading"}}, "name"=>"card__generic"}]
      expect(PageSerializer::ListPageSerializer).to have_received(:new).with(page_title: "proposed-negative-statutory-instruments.index.title", list_components: list_components, request_id: '|1234abcd.', data_alternates: data_alternates, request_original_url: request.original_url)
    end
  end

  describe 'GET show' do
    let(:data_alternates) do
      [{
         :href => "#{ENV['PARLIAMENT_BASE_URL']}/proposed_negative_statutory_instrument_by_id.nt?proposed_negative_statutory_instrument_id=12345678",
         :type => "application/n-triples" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/proposed_negative_statutory_instrument_by_id.ttl?proposed_negative_statutory_instrument_id=12345678",
         :type => "text/turtle" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/proposed_negative_statutory_instrument_by_id.tsv?proposed_negative_statutory_instrument_id=12345678",
         :type => "text/tab-separated-values" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/proposed_negative_statutory_instrument_by_id.csv?proposed_negative_statutory_instrument_id=12345678",
         :type => "text/csv" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/proposed_negative_statutory_instrument_by_id.rj?proposed_negative_statutory_instrument_id=12345678",
         :type => "application/json+rdf" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/proposed_negative_statutory_instrument_by_id.json?proposed_negative_statutory_instrument_id=12345678",
         :type => "application/json+ld" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/proposed_negative_statutory_instrument_by_id.xml?proposed_negative_statutory_instrument_id=12345678",
         :type => "application/rdf+xml" }]
    end

    before(:each) do
      allow(PageSerializer::ProposedNegativeStatutoryInstrumentsShowPageSerializer).to receive(:new)
      allow(controller.request).to receive(:env).and_return({'ApplicationInsights.request.id' => '|1234abcd.'})

      get :show, params: { proposed_negative_statutory_instrument_id: 12345678 }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @statutory_instrument' do
      expect(assigns(:proposed_negative_statutory_instrument)).to be_a(Grom::Node)
      expect(assigns(:proposed_negative_statutory_instrument).type).to include('https://id.parliament.uk/schema/ProposedNegativeStatutoryInstrumentPaper')
    end

    it 'calls the serializer correctly' do
      statutory_instrument = assigns(:proposed_negative_statutory_instrument)

      expect(PageSerializer::ProposedNegativeStatutoryInstrumentsShowPageSerializer).to have_received(:new).with(proposed_negative_statutory_instrument: statutory_instrument, request_id: '|1234abcd.', data_alternates: data_alternates, request_original_url: request.original_url)
    end
  end
end
