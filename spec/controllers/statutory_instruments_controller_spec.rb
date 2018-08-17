# -*- coding: utf-8 -*-
require 'rails_helper'

RSpec.describe StatutoryInstrumentsController do
  describe 'GET show' do
    before(:each) do
      get :show, params: { statutory_instrument_id: 12345678 }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'should return the text OK' do
      expect(JSON.parse(response.body)).to eq({ 'message' => 'This is some JSON.' })
    end
  end
end
