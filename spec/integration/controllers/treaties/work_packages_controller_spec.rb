require_relative '../../../rails_helper'

RSpec.describe Treaties::WorkPackagesController, vcr: true do
  describe 'GET index' do
    before(:each) do
      allow_any_instance_of(PageSerializer::ListPageSerializer).to receive(:request_id) { 123456 }
    end

    context 'navigating to the index page' do
      it 'renders expected JSON output' do
        get '/treaties/gzoa2qc8/work-packages'
        filtered_response_body = filter_sensitive_data(response.body)

        expected_json = get_fixture('index', 'fixture')

        expect(JSON.parse(filtered_response_body).to_yaml).to eq(expected_json)
      end
    end
  end
end
