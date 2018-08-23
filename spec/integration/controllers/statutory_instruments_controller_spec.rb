require_relative '../../rails_helper'

RSpec.describe StatutoryInstrumentsController, vcr: true do
  describe 'GET index' do
    before(:each) do
      allow_any_instance_of(StatutoryInstrumentsController).to receive(:app_insights_request_id) { 123456 }
    end

    context 'navigating to the index page' do
      it 'renders expected JSON output' do
        get '/statutory-instruments'

        expected_json = get_fixture('index', 'fixture')

        expect(JSON.parse(response.body).to_yaml).to eq(expected_json)
      end
    end
  end

  describe 'GET show' do
    before(:each) do
      allow_any_instance_of(StatutoryInstrumentsController).to receive(:app_insights_request_id) { 123456 }
    end

    context 'navigating to the show page' do
      it 'renders expected JSON output' do
        get '/statutory-instruments/1234567'

        expected_json = get_fixture('show', 'fixture')

        expect(JSON.parse(response.body).to_yaml).to eq(expected_json)
      end
    end
  end
end
