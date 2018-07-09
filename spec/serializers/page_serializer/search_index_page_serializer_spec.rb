require_relative '../../rails_helper'

describe PageSerializer::SearchIndexPageSerializer, vcr: true do
  let(:result_one) {
    double(
        'result_one',
        title: 'Result one',
        url: 'link',
        formatted_url: 'link...',
        hint_types: ['pdf'],
        content: 'Content one'
    )
  }

  let(:result_two) {
    double(
        'result_two',
        title: 'Result two',
        url: 'link',
        formatted_url: 'link...',
        hint_types: [],
        content: 'Content two'
    )
  }

  let(:result_three) {
    double(
        'result_three',
        title: 'Result three',
        url: 'link',
        formatted_url: 'link...',
        hint_types: ['Beta'],
        content: 'Content three'
    )
  }

  let(:results) { double('results', totalResults: 658, entries: [result_one, result_two, result_three]) }
  let(:search_index_page_serializer) { described_class.new }

  context '#to_h' do
    context 'without a query' do
      it 'produces the correct hash' do
        expected = get_fixture('correct')

        expect(search_index_page_serializer.to_yaml).to eq(expected)
      end
    end

    context 'with a flash message' do
      it 'produces the correct hash' do
        serializer = described_class.new(flash_message: 'some flash message')

        expected = get_fixture('with_flash_message')

        expect(serializer.to_yaml).to eq(expected)
      end
    end

    context 'with a query' do
      pagination_hash = { start_index: 11, count: 100, results_total: 345, query: 'hello' }
      let(:serializer) { described_class.new(query: 'hello', results: results, pagination_hash: pagination_hash) }

      it 'produces the correct hash' do
        expected = get_fixture('with_a_query')

        expect(serializer.to_yaml).to eq(expected)
      end
    end

    context 'when there are no results' do
      pagination_hash = { start_index: 1, count: 10, results_total: 0, query: 'hello' }

      it 'produces the correct hash' do
        allow(results).to receive(:totalResults) { 0 }
        serializer = described_class.new(query: 'hello', results: results, pagination_hash: pagination_hash)

        expected = get_fixture('no_results')

        expect(serializer.to_yaml).to eq(expected)
      end
    end
  end

  context 'the serializers are correctly called' do
    context 'without a query' do
      it '#content' do
        allow(ComponentSerializer::SectionComponentSerializer).to receive(:new)

        allow(search_index_page_serializer).to receive(:section_primary_components) { [] }

        search_index_page_serializer.to_h

        expect(ComponentSerializer::SectionComponentSerializer).to have_received(:new).with([], type: 'primary', content_flag: true)
      end

      it '#section_primary_components' do
        allow(ComponentSerializer::HeadingComponentSerializer).to receive(:new)
        allow(ComponentSerializer::SearchFormComponentSerializer).to receive(:new)

        search_index_page_serializer.to_h

        expect(ComponentSerializer::HeadingComponentSerializer).to have_received(:new).with(content: ['search.search-heading'], size: 1)
        expect(ComponentSerializer::SearchFormComponentSerializer).to have_received(:new)
      end
    end

    context 'with a query' do
      let(:results) { double('results', totalResults: 123) }
      let(:page_with_query) { described_class.new(query: 'hello', results: results, pagination_hash: { some: 'thing' }) }

      before(:each) do
        pagination_helper_instance = double('pagination_helper_instance', navigation_section_components: true)

        allow(PaginationHelper).to receive(:new) { pagination_helper_instance }
        allow(SearchResultHelper).to receive(:create_search_results) { 'search results' }
      end

      context '#content' do
        before(:each) do
          allow(ComponentSerializer::SectionComponentSerializer).to receive(:new)
          allow(page_with_query).to receive(:section_primary_components) { [] }
          allow(page_with_query).to receive(:results_section_components) { [] }
        end

        it 'if the total number of results are greater than or equal to one 1' do
          page_with_query.to_h

          expect(ComponentSerializer::SectionComponentSerializer).to have_received(:new).with([], type: 'primary')
          expect(ComponentSerializer::SectionComponentSerializer).to have_received(:new).with([], content_flag: true)
          expect(ComponentSerializer::SectionComponentSerializer).to have_received(:new).with(true)
        end

        it 'if the total number of results is less than 1' do
          allow(results).to receive(:totalResults) { 0 }

          page_with_query.to_h

          expect(ComponentSerializer::SectionComponentSerializer).to have_received(:new).with([], type: 'primary')
          expect(ComponentSerializer::SectionComponentSerializer).to have_received(:new).with([], content_flag: true)
          expect(ComponentSerializer::SectionComponentSerializer).not_to have_received(:new).with(true)
        end
      end

      context '#results_section_components' do
        before(:each) do
          allow(ComponentSerializer::HeadingComponentSerializer).to receive(:new)
          allow(ComponentSerializer::StatusComponentSerializer).to receive(:new)
          allow(ComponentSerializer::ListComponentSerializer).to receive(:new)
        end

        it 'calls the correct serializers' do
          page_with_query.send(:results_section_components)

          expect(ComponentSerializer::HeadingComponentSerializer).to have_received(:new).with(translation_key: 'search.count', translation_data: { count: 123 } , size: 2)
          expect(ComponentSerializer::StatusComponentSerializer).to have_received(:new).with(type: 'highlight', display_data: [{ component: 'status', variant: 'highlight' }], components: [ComponentSerializer::ParagraphComponentSerializer.new([{ content: 'search.new-search' }]).to_h])
          expect(ComponentSerializer::ListComponentSerializer).to have_received(:new).with(display: 'generic', display_data: [{ component: 'list', variant: 'block' }], components: 'search results' )
        end

        it 'if there are no results' do
          allow(results).to receive(:totalResults) { 0 }

          page_with_query.send(:results_section_components)

          expect(ComponentSerializer::HeadingComponentSerializer).to have_received(:new).with(content: ['search.no-results'], size: 2)
        end
      end
    end
  end
end
