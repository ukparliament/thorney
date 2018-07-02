require_relative '../rails_helper'

RSpec.describe SearchService, vcr: true do
  let(:params) { { q: 'banana', start_index: '21', count: '10' } }
  let(:subject) { described_class.new(123, '/search', params) }

  context 'methods' do
    before(:each) do
      allow(Parliament::Request::OpenSearchRequest).to receive(:configure_description_url)
    end

    it '#query_parameter' do
      expect(subject.sanitised_query).to eq 'banana'
    end

    it '#escaped_query_parameter' do
      params[:q] = 'hello there'

      expect(subject.escaped_query).to eq 'hello+there'
    end

    it '#start_index' do
      expect(subject.start_index).to eq 21
    end

    it '#count' do
      expect(subject.count).to eq 10
    end

    it '#pagination_hash' do
      allow(subject).to receive(:total_results) { 100 }
      expected_hash = {
          start_index: 21,
          count: 10,
          results_total: 100,
          search_url: '/search',
          query: 'banana'
      }

      expect(subject.pagination_hash).to eq expected_hash
    end

    context 'fetch_description' do
      it 'successful fetching' do
        subject.fetch_description

        expect(Parliament::Request::OpenSearchRequest).to have_received(:configure_description_url).with(ENV['OPENSEARCH_DESCRIPTION_URL'], 123)
      end

      it 'errors' do
        allow(Parliament::Request::OpenSearchRequest).to receive(:configure_description_url) { raise raise Errno::ECONNREFUSED }

        expect{ subject.fetch_description }.to raise_error(StandardError, "There was an error getting the description file from OPENSEARCH_DESCRIPTION_URL environment variable value: '#{ENV['OPENSEARCH_DESCRIPTION_URL']}' - Connection refused")
      end
    end

    context '#open_search_param' do
      before(:each) do
        allow(Parliament::Request::OpenSearchRequest).to receive(:open_search_parameters) { { start_index: 0 } }
      end

      it 'start_index defaults to OpenSearch default if it doesn\'t exist' do
        params = {}
        subject = described_class.new(123, '/search', params)

        expect(subject.start_index).to eq 0
      end

      it 'start_index defaults to OpenSearch default if it is an empty string' do
        params = { start_index: '' }
        subject = described_class.new(123, '/search', params)

        expect(subject.start_index).to eq 0
      end

      it 'start_index defaults to OpenSearch default if it is a non-integer value' do
        params = { start_index: 'foo' }
        subject = described_class.new(123, '/search', params)

        expect(subject.start_index).to eq 0
      end

      it 'start_index is valid value' do
        params = { start_index: '5' }
        subject = described_class.new(123, '/search', params)

        expect(subject.start_index).to eq 5
      end
    end
  end

  context 'external requests' do
    it 'sends the expected headers to the search API' do
      subject.fetch_description
      subject.results

      expect(WebMock).to have_requested(:get, ENV['OPENSEARCH_DESCRIPTION_URL']).with(headers: {'Accept' => ['*/*', 'application/opensearchdescription+xml']})
      expect(WebMock).to have_requested(:get, 'https://api-parliament-uk.azure-api.net/Staging/search?count=10&q=banana&start=21').with(headers: {'Accept'=>['*/*', 'application/atom+xml']})
    end
  end
end