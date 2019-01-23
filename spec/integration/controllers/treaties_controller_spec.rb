require_relative '../../rails_helper'

RSpec.describe TreatiesController, vcr: true do
  describe 'GET index' do
    before(:each) do
      allow_any_instance_of(PageSerializer::ListPageSerializer).to receive(:request_id) { 123456 }
    end

    context 'navigating to the index page' do
      it 'renders expected JSON output' do
        get '/treaties'
        filtered_response_body = filter_sensitive_data(response.body)

        expected_json = get_fixture('index', 'fixture')

        expect(JSON.parse(filtered_response_body).to_yaml).to eq(expected_json)
      end
    end
  end

  describe 'GET show' do
    before(:each) do
      allow_any_instance_of(PageSerializer::TreatiesShowPageSerializer).to receive(:request_id) { 123456 }
    end

    context 'navigating to the show page' do
      it 'renders expected JSON output' do
        get '/treaties/gzoa2qc8'
        filtered_response_body = filter_sensitive_data(response.body)

        expected_json = get_fixture('show', 'fixture')

        expect(JSON.parse(filtered_response_body).to_yaml).to eq(expected_json)
      end
    end
  end

  describe 'GET lookup' do
    context 'being redirected to the show page' do
      it 'renders expected JSON output' do
        get '/treaties/lookup?source=treatyName&id=Treaty test 1'

        expect(response.body).to eq('<html><body>You are being <a href="https://www.example.com/treaties/gzoa2qc8">redirected</a>.</body></html>')
      end
    end
  end
end
