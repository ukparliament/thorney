require_relative '../../rails_helper'

describe PageSerializer::SearchIndexPageSerializer do
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

    context 'with a query' do
      pagination_hash = { start_index: 11, count: 100, results_total: 345, query: 'hello' }
      let(:serializer) { described_class.new(query: 'hello', results: results, pagination_hash: pagination_hash) }

      it 'produces the correct hash' do
        expected = get_fixture('with_a_query')

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

        expect(ComponentSerializer::HeadingComponentSerializer).to have_received(:new).with(heading: ['search.heading'], size: 1)
        expect(ComponentSerializer::SearchFormComponentSerializer).to have_received(:new)
      end
    end
  end
end
