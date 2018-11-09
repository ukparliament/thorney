require_relative '../../../rails_helper'

RSpec.describe WorkPackages::PaperTypesController, vcr: true do
  describe 'GET index' do
    before(:each) do
      allow_any_instance_of(PageSerializer::ListPageSerializer).to receive(:request_id) { 123456 }
    end

    context 'navigating to the index page' do
      it 'renders expected JSON output' do
        get '/work-packages/paper-types'
        filtered_response_body = filter_sensitive_data(response.body)
create_fixture(filtered_response_body, 'index', 'fixture')
        expected_json = get_fixture('index', 'fixture')

        expect(JSON.parse(filtered_response_body).to_yaml).to eq(expected_json)
      end
    end

    context 'navigating to the show page' do
      it 'renders expected JSON output' do
        get '/work-packages/paper-types/statutory-instruments'
        filtered_response_body = filter_sensitive_data(response.body)

        expected_json = get_fixture('show', 'fixture')

        expect(JSON.parse(filtered_response_body).to_yaml).to eq(expected_json)
      end
    end

    context 'navigating to the current page' do
      it 'renders expected JSON output' do
        get '/work-packages/paper-types/statutory-instruments/current'
        filtered_response_body = filter_sensitive_data(response.body)

        expected_json = get_fixture('current', 'fixture')

        expect(JSON.parse(filtered_response_body).to_yaml).to eq(expected_json)
      end
    end
  end
end
