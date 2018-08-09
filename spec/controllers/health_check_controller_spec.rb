# -*- coding: utf-8 -*-
require 'rails_helper'

RSpec.describe HealthCheckController do
  describe 'GET index' do
    before(:each) do
      get :index
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'should return the text OK' do
      expect(response.body).to eq 'OK'
    end
  end
end
