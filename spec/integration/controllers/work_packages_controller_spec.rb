require_relative '../../rails_helper'

RSpec.describe WorkPackagesController, vcr: true do
  describe 'GET current' do
    before(:each) do
      allow_any_instance_of(PageSerializer::ListPageSerializer).to receive(:request_id) { 123456 }
    end

    context 'navigating to the current page' do
      it 'renders expected JSON output' do
        get '/work-packages/current'
        filtered_response_body = filter_sensitive_data(response.body)

        expected_json = get_fixture('current', 'fixture')

        expect(JSON.parse(filtered_response_body).to_yaml).to eq(expected_json)
      end
    end
  end
end
