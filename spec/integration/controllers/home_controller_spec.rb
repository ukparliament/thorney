require_relative '../../rails_helper'

RSpec.describe HomeController, vcr: true do
  describe 'GET index' do
    before(:each) do
      allow_any_instance_of(PageSerializer::HomePageSerializer).to receive(:request_id) { 123456 }
    end

    context 'navigating to the index page' do
      it 'renders expected JSON output' do
        get '/'

        expected_json = get_fixture('index', 'fixture')

        expect(JSON.parse(response.body).to_yaml).to eq(expected_json)
      end
    end
  end
end
