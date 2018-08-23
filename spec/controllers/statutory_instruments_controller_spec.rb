# -*- coding: utf-8 -*-
require 'rails_helper'

RSpec.describe StatutoryInstrumentsController, vcr: true do
  describe 'GET index' do
    before(:each) do
      allow(PageSerializer::StatutoryInstrumentsIndexPageSerializer).to receive(:new)
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
      statutory_instruments = assigns(:statutory_instruments)

      expect(PageSerializer::StatutoryInstrumentsIndexPageSerializer).to have_received(:new).with(statutory_instruments: statutory_instruments, request_id: '|1234abcd.')
    end
  end

  describe 'GET show' do
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

      expect(PageSerializer::StatutoryInstrumentsShowPageSerializer).to have_received(:new).with(statutory_instrument: statutory_instrument, request_id: '|1234abcd.')
    end
  end
end
