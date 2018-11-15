require_relative '../../../../../rails_helper'

RSpec.describe Groups::MadeAvailable::AvailabilityTypes::LaidPapersController, vcr: true do
  describe 'GET index' do
    before(:each) do
      allow_any_instance_of(PageSerializer::ListPageSerializer).to receive(:request_id) { 123456 }
    end

    context 'navigating to the index page' do
      it 'renders expected JSON output' do
        get '/groups/XouN12Ow/made-available/availability-types/laid-papers'
        filtered_response_body = filter_sensitive_data(response.body)
create_fixture(filtered_response_body, 'index', 'fixture')
        expected_json = get_fixture('index', 'fixture')

        expect(JSON.parse(filtered_response_body).to_yaml).to eq(expected_json)
      end
    end
  end
end
