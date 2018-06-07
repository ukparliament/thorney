require_relative '../rails_helper'

RSpec.describe ApplicationController do
  let(:serializer) { double('serializer') }
  let(:response) { double('response', headers: {}) }

  context 'rescue_from' do
    class ErrorResponse
      def code
        123
      end

      def message
        'Error message'
      end
    end

    controller do
      def test_client_error
        raise Parliament::ClientError.new('url', ErrorResponse.new)
      end

      def test_no_content_response_error
        raise Parliament::NoContentResponseError.new('url', ErrorResponse.new)
      end
    end

    before(:each) do
      routes.draw do
        get 'test_client_error' => 'anonymous#test_client_error'
        get 'test_no_content_response_error' => 'anonymous#test_no_content_response_error'
      end
    end

    it 'rescues from client error' do
      expect{ get :test_client_error }.to raise_error(ActionController::RoutingError, '123 HTTP status code received from: url - Error message')
    end

    it 'rescues from no content response error' do
      expect{ get :test_no_content_response_error }.to raise_error(ActionController::RoutingError, '123 HTTP status code received from: url - Error message')
    end
  end

  context '#render_page' do
    it 'calls the serializer\'s #to_h method and sets the required response headers' do
      allow(subject).to receive(:render)
      allow(serializer).to receive(:to_h)

      subject.render_page(serializer, response)

      headers = {}
      headers['Content-Type'] = 'application/x-shunter+json'

      expect(response.headers).to eq headers
      expect(subject).to have_received(:render).with(json: serializer.to_h)
    end
  end
end
