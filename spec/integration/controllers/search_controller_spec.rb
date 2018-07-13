require_relative '../../rails_helper'

RSpec.describe SearchController, vcr: true do
  describe 'GET index' do
    context 'navigating to the search page' do
      it 'renders expected JSON output' do
        get '/search'

        expected_json = get_fixture('index', 'search')

        expect(JSON.parse(response.body).to_yaml).to eq(expected_json)
      end
    end

    context 'with a query' do
      it 'renders expected JSON output' do
        get '/search?q=hello'

        expected_json = get_fixture('index', 'with_a_query')

        expect(JSON.parse(response.body).to_yaml).to eq(expected_json)
      end

      it 'for the second page' do
        get 'https://beta.parliament.uk/search?count=10&q=diane+abbott&start_index=11'

        expected_json = get_fixture('index', 'second_page')

        expect(JSON.parse(response.body).to_yaml).to eq(expected_json)
      end

      it 'for the last page' do
        get '/search?count=10&q=diane+abbott&start_index=7541'

        expected_json = get_fixture('index', 'last_page')

        expect(JSON.parse(response.body).to_yaml).to eq(expected_json)
      end

      it 'with an empty query' do
        get '/search?q='

        expected_json = get_fixture('index', 'empty_query')

        expect(JSON.parse(response.body).to_yaml).to eq(expected_json)
      end

      it 'when there are no results' do
        get '/search?q=dfgdfh89rhosiubreoweh'

        expected_json = get_fixture('index', 'no_results')

        expect(JSON.parse(response.body).to_yaml).to eq(expected_json)
      end
    end

    context 'for a query with 8 pages of results' do
      it 'for the first page' do
        get '/search?q=poop'

        expected_json = get_fixture('index', 'poop_first_page')

        expect(JSON.parse(response.body).to_yaml).to eq(expected_json)
      end

      it 'for the last page' do
        get '/search?count=10&q=poop&start_index=71'

        expected_json = get_fixture('index', 'poop_last_page')

        expect(JSON.parse(response.body).to_yaml).to eq(expected_json)
      end
    end
  end
end