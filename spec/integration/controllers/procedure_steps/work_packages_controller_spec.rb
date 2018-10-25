require_relative '../../../rails_helper'

RSpec.describe ProcedureSteps::WorkPackagesController, vcr: true do
  describe 'GET index' do
    before(:each) do
      allow_any_instance_of(PageSerializer::ListPageSerializer).to receive(:request_id) { 123456 }
    end

    context 'navigating to the index page' do
      it 'renders expected JSON output' do
        get '/procedure-steps/e9G2vHbc/work-packages'
        filtered_response_body = filter_sensitive_data(response.body)

        expected_json = get_fixture('index', 'fixture')

        expect(JSON.parse(filtered_response_body).to_yaml).to eq(expected_json)
      end

      context 'when a business item does not have a date' do
        it 'renders expected JSON output' do
          get '/procedure-steps/e9G2vHbc/work-packages'
          filtered_response_body = filter_sensitive_data(response.body)

          expected_json = get_fixture('index', 'fixture_with_missing_business_item_date')

          expect(JSON.parse(filtered_response_body).to_yaml).to eq(expected_json)
        end
      end
    end
  end
end
