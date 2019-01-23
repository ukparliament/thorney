require_relative '../../rails_helper'

RSpec.describe StatutoryInstrumentsController, vcr: true do
  describe 'GET index' do
    before(:each) do
      allow_any_instance_of(PageSerializer::ListPageSerializer).to receive(:request_id) { 123456 }
    end

    context 'navigating to the index page' do
      it 'renders expected JSON output' do
        get '/statutory-instruments'
        filtered_response_body = filter_sensitive_data(response.body)

        expected_json = get_fixture('index', 'fixture')

        expect(JSON.parse(filtered_response_body).to_yaml).to eq(expected_json)
      end
    end
  end

  describe 'GET show' do
    before(:each) do
      allow_any_instance_of(PageSerializer::StatutoryInstrumentsShowPageSerializer).to receive(:request_id) { 123456 }
    end

    context 'navigating to the show page' do
      it 'renders expected JSON output' do
        get '/statutory-instruments/1234567'
        filtered_response_body = filter_sensitive_data(response.body)

        expected_json = get_fixture('show', 'fixture')

        expect(JSON.parse(filtered_response_body).to_yaml).to eq(expected_json)
      end
    end
  end

  describe 'GET lookup' do
    context 'being redirected to the show page' do
      it 'renders expected JSON output' do
        get '/statutory-instruments/lookup?source=statutoryInstrumentPaperName&id=Dorset (Electoral Changes) Order 2018'

        expect(response.body).to eq('<html><body>You are being <a href="https://www.example.com/statutory-instruments/mLomz9Wq">redirected</a>.</body></html>')
      end
    end
  end
end
