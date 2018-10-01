require_relative '../../rails_helper'

RSpec.describe GroupsController, vcr: true do
  describe 'GET index' do
    before(:each) do
      allow_any_instance_of(GroupsController).to receive(:app_insights_request_id) { 123456 }
    end

    context 'navigating to the index page' do
      it 'renders expected JSON output' do
        get '/groups'

        expected_json = get_fixture('index', 'fixture')

        expect(JSON.parse(response.body).to_yaml).to eq(expected_json)
      end
    end
  end

  describe 'GET show' do
    before(:each) do
      allow_any_instance_of(GroupsController).to receive(:app_insights_request_id) { 123456 }
    end

    context 'navigating to the show page' do
      it 'renders expected JSON output' do
        get '/groups/0RNgrC4q'

        expected_json = get_fixture('show', 'fixture')

        expect(JSON.parse(response.body).to_yaml).to eq(expected_json)
      end
    end
  end
end
