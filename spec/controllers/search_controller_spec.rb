# -*- coding: utf-8 -*-
require 'rails_helper'

RSpec.describe SearchController, vcr: true do
  describe 'GET index' do
    context 'with no query' do
      before(:each) do
        allow(PageSerializer::SearchPage::LandingPageSerializer).to receive(:new)

        get :index
      end

      it 'should have a response with http status ok (200)' do
        expect(response).to have_http_status(:ok)
      end

      it 'calls the serializer correctly' do
        expect(PageSerializer::SearchPage::LandingPageSerializer).to have_received(:new)
      end
    end

    context 'with a query' do
      context 'with a valid search' do
        before(:each) do
          allow_any_instance_of(ActionController::TestRequest).to receive(:env).and_return({'ApplicationInsights.request.id' => '|1234abcd.'})

          allow(PageSerializer::SearchPage::ResultsPageSerializer).to receive(:new)

          search_service_instance = double(
              'search_service_instance',
              query_nil_or_empty?: false,
              fetch_description: true,
              sanitised_query: 'banana',
              results: [1, 2, 3],
              count: 123,
              total_results: 4000,
              start_index: 10,
              pagination_hash: 'pagination_hash'

          )

          allow(SearchService).to receive(:new) { search_service_instance }

          get :index, params: { q: 'banana' }
        end

        it 'should have a response with http status ok (200)' do
          expect(response).to have_http_status(:ok)
        end

        it 'instantiates the SearchService' do
          expect(SearchService).to have_received(:new).with('|1234abcd.', '/search', controller.params)
        end

        it 'calls the serializer with the correct arguments' do
          expect(PageSerializer::SearchPage::ResultsPageSerializer).to have_received(:new).with(request: request, query: 'banana', results: [1, 2, 3], pagination_hash: 'pagination_hash')
        end
      end

      context 'an invalid search' do
        before(:each) do
          allow(controller.request).to receive(:env).and_return({'ApplicationInsights.request.id' => '|1234abcd.', 'HTTP_HOST' => 'test.host'})
          allow(PageSerializer::SearchPage::ResultsPageSerializer).to receive(:new)


          get :index, params: { q: 'fdsfsd' }
        end

        it 'should have a response with http status ok (200)' do
          expect(response).to have_http_status(:ok)
        end

        it 'calls the serializer with the correct arguments' do
          pagination_hash = {
              start_index: controller.send(:search_service).start_index,
              count: controller.send(:search_service).count,
              results_total: controller.send(:search_service).total_results,
              search_path: '/search',
              query: 'fdsfsd'
          }

          expect(PageSerializer::SearchPage::ResultsPageSerializer).to have_received(:new).with(request: request, query: 'fdsfsd', results: an_instance_of(Feedjira::Parser::Atom), pagination_hash: pagination_hash)
        end
      end

      context 'with an empty string' do
        before(:each) do
          allow(controller.request).to receive(:env).and_return({'ApplicationInsights.request.id' => '|1234abcd.', 'HTTP_HOST' => 'test.host'})
          allow(PageSerializer::SearchPage::LandingPageSerializer).to receive(:new)

          get :index, params: { q: '' }
        end

        it 'should have a response with http status ok (200)' do
          expect(response).to have_http_status(:ok)
        end

        it 'calls the serializer with the correct arguments' do
          expect(PageSerializer::SearchPage::LandingPageSerializer).to have_received(:new).with(request: request, flash_message: I18n.t('search_controller.index.flash'))
        end
      end

      context 'search for a non-ascii character' do
        it 'should have a response with http status ok (200)' do
          get :index, params: { q: 'Ü' }

          expect(response).to have_http_status(:ok)
        end
      end

      context 'prevents xss on search' do
        before(:each) do
          get :index, params: { q: '<script>alert(document.cookie)</script>'}
        end

        it 'should prevent xss on search' do
          expect(response.body).not_to include('<script>alert(document.cookie)</script>')
        end

        it 'should sanitize the search term' do
          expect(response.body).to include('alert(document.cookie)')
        end
      end

      context 'with no count or start_index value' do
        before(:each) do
          get :index, params: { q: 'Matt Rayner', count: '', start_index: '' }
        end

        it 'should have a response with http status ok (200)' do
          expect(response).to have_http_status(:ok)
        end

        it 'should set count to the default value' do
          expect(controller.send(:search_service).count).to eq(10)
        end

        it 'should set start_index to the default value' do
          expect(controller.send(:search_service).start_index).to eq(1)
        end
      end

      context 'rescuing from errors' do
        it 'when configuring the description url' do
          allow(Parliament::Request::OpenSearchRequest).to receive(:configure_description_url) { raise Errno::ECONNREFUSED }

          expect{ get :index, params: { q: 'Allan Wazacz' } }.to raise_error(StandardError, "There was an error getting the description file from OPENSEARCH_DESCRIPTION_URL environment variable value: '#{ENV['OPENSEARCH_DESCRIPTION_URL']}' - Connection refused")
        end

        it 'when making the search request' do
          open_search_request = double('open_search_request', base_url: 'some_base_url')
          allow(open_search_request).to receive(:get) { raise Parliament::ServerError.new('url', double('message', code: '123', message: 'message')) }

          allow(Parliament::Request::OpenSearchRequest).to receive(:new) { open_search_request }

          allow(controller.request).to receive(:env).and_return({'ApplicationInsights.request.id' => '|1234abcd.', 'HTTP_HOST' => 'test.host'})

          allow(PageSerializer::SearchPage::ResultsPageSerializer).to receive(:new) { double('serializer', to_h: true) }

          get :index, params: { q: 'Allan Wazacz' }

          expect(PageSerializer::SearchPage::ResultsPageSerializer).to have_received(:new).with(request: request, query: 'Allan Wazacz')
        end
      end
    end
  end

  describe 'GET opensearch' do
    before(:each) do
      get :opensearch
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'renders the expected XML' do
      xml_file=<<~XML
        <?xml version="1.0" encoding="UTF-8"?>
        <OpenSearchDescription xmlns="http://a9.com/-/spec/opensearch/1.1/">
          <ShortName>UK Parliament</ShortName>
          <Description>Search UK Parliament online content</Description>
          <Image height="16" width="16" type="image/x-icon">https://test.host/favicon.ico</Image>
          <Url type="text/html" template="https://test.host/search?q={searchTerms}&amp;start_index={startIndex?}&amp;count={count?}" />
        </OpenSearchDescription>
      XML

      expect(response.body).to eq(xml_file)
    end

    it 'uses the expected content-type header' do
      expect(response.headers['Content-Type']).to eq('application/opensearchdescription+xml; charset=utf-8')
    end
  end
end
