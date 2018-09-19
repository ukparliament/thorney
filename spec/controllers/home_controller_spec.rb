require 'rails_helper'

RSpec.describe HomeController do
  describe 'GET index' do
    before(:each) do
      allow(PageSerializer::HomePageSerializer).to receive(:new)

      get :index
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'calls the serializer correctly' do
      expect(PageSerializer::HomePageSerializer).to have_received(:new)
    end

  end
end
