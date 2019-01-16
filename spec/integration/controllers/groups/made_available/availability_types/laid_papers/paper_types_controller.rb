require_relative '../../../../../../rails_helper'

RSpec.describe Groups::MadeAvailable::AvailabilityTypes::LaidPapers::PaperTypesController, vcr: true do
  describe 'GET index' do
    before(:each) do
      allow_any_instance_of(PageSerializer::ListPageSerializer).to receive(:request_id) { 123456 }
    end

    context 'navigating to the index page' do
      it 'renders expected JSON output' do
        get '/groups/XouN12Ow/made-available/availability-types/laid-papers/paper-types'
        filtered_response_body = filter_sensitive_data(response.body)

        expected_json = get_fixture('index', 'fixture')

        expect(JSON.parse(filtered_response_body).to_yaml).to eq(expected_json)
      end
    end

    context 'navigating to the show page (statutory-instruments)' do
      it 'renders expected JSON output' do
        get '/groups/XouN12Ow/made-available/availability-types/laid-papers/paper-types/statutory-instruments'
        filtered_response_body = filter_sensitive_data(response.body)

        expected_json = get_fixture('show', 'fixture')

        expect(JSON.parse(filtered_response_body).to_yaml).to eq(expected_json)
      end
    end
  end
end
