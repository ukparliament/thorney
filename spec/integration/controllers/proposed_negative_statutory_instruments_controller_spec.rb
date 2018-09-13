require_relative '../../rails_helper'

RSpec.describe ProposedNegativeStatutoryInstrumentsController, vcr: true do
  describe 'GET index' do
    before(:each) do
      allow_any_instance_of(ProposedNegativeStatutoryInstrumentsController).to receive(:app_insights_request_id) { 123456 }
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
      allow_any_instance_of(ProposedNegativeStatutoryInstrumentsController).to receive(:app_insights_request_id) { 123456 }
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
end
