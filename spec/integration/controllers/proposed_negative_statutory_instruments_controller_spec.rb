require_relative '../../rails_helper'

RSpec.describe ProposedNegativeStatutoryInstrumentsController, vcr: true do
  describe 'GET index' do
    before(:each) do
      allow_any_instance_of(PageSerializer::ListPageSerializer).to receive(:request_id) { 123456 }
    end

    context 'navigating to the index page' do
      it 'renders expected JSON output' do
        get '/proposed-negative-statutory-instruments'
        filtered_response_body = filter_sensitive_data(response.body)

        expected_json = get_fixture('index', 'fixture')

        expect(JSON.parse(filtered_response_body).to_yaml).to eq(expected_json)
      end
    end
  end

  describe 'GET show' do
    before(:each) do
      allow_any_instance_of(PageSerializer::ProposedNegativeStatutoryInstrumentsShowPageSerializer).to receive(:request_id) { 123456 }
    end

    context 'navigating to the show page' do
      it 'renders expected JSON output' do
        get '/proposed-negative-statutory-instruments/12345678'
        filtered_response_body = filter_sensitive_data(response.body)

        expected_json = get_fixture('show', 'fixture')

        expect(JSON.parse(filtered_response_body).to_yaml).to eq(expected_json)
      end
    end
  end

  describe 'GET lookup' do
    context 'being redirected to the show page' do
      it 'renders expected JSON output' do
        get '/proposed-negative-statutory-instruments/lookup?source=proposedNegativeStatutoryInstrumentPaperName&id=Animal Breeding (Amendment) (EU Exit) Regulations 2018'

        expect(response.body).to eq('<html><body>You are being <a href="http://www.example.com/proposed-negative-statutory-instruments/VUWxOw5e">redirected</a>.</body></html>')
      end
    end
  end
end
