require_relative '../../../rails_helper'

RSpec.describe PageSerializer::SearchPage::ResultsPageSerializer do
  let(:pagination_hash) { { start_index: 11, count: 100, results_total: 345, query: 'hello' } }
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
  let(:subject) { described_class.new(query: 'hello', results: results, pagination_hash: pagination_hash) }

  context '#to_h' do
    context 'with a query' do
      it 'produces the correct hash' do

        expected = get_fixture('with_a_query')

        expect(subject.to_yaml).to eq(expected)
      end
    end

    context 'with no results' do
      it 'produces the correct hash' do
        allow(results).to receive(:totalResults) { 0 }

        expected = get_fixture('no_results')

        expect(subject.to_yaml).to eq(expected)
      end
    end
  end

  context 'the serializers are correctly called' do
    context '#content' do
      before(:each) do
        allow(ComponentSerializer::SectionComponentSerializer).to receive(:new)

        allow(subject).to receive(:section_primary_components) { [] }
        allow(subject).to receive(:results_section_components) { 'results section components' }

        subject.instance_variable_set(:@pagination_helper, double('pagination_helper', navigation_section_components: 'navigation section components'))
      end

      it 'with results' do
        subject.to_h

        expect(ComponentSerializer::SectionComponentSerializer).to have_received(:new).with(components: [], type: 'primary')
        expect(ComponentSerializer::SectionComponentSerializer).to have_received(:new).with(components: 'results section components', content_flag: true)
      end

      it 'without results' do
        allow(results).to receive(:totalResults) { 0 }

        subject.to_h

        expect(ComponentSerializer::SectionComponentSerializer).to have_received(:new).with(components: [], type: 'primary')
        expect(ComponentSerializer::SectionComponentSerializer).to have_received(:new).with(components: 'results section components', content_flag: true)
      end
    end

    context '#results_section_components' do
      before(:each) do
        allow(ComponentSerializer::HeadingComponentSerializer).to receive(:new)
        allow(ComponentSerializer::StatusComponentSerializer).to receive(:new)
        allow(ComponentSerializer::ListComponentSerializer).to receive(:new)
      end

      it 'with results' do
        subject.to_h

        expect(ComponentSerializer::HeadingComponentSerializer).to have_received(:new).with(translation_key: 'search.count', translation_data: { count: 658 }, size: 2)
        expect(ComponentSerializer::ListComponentSerializer).to have_received(:new).with(display: 'generic', display_data: [{ component: 'list', variant: 'block' }], components: SearchResultHelper.create_search_results(results))
      end

      it 'without results' do
        allow(results).to receive(:totalResults) { 0 }

        subject.to_h

        expect(ComponentSerializer::HeadingComponentSerializer).to have_received(:new).with(content: ['search.no-results'], size: 2)
        expect(ComponentSerializer::ListComponentSerializer).not_to have_received(:new).with(display: 'generic', display_data: [{ component: 'list', variant: 'block' }], components: SearchResultHelper.create_search_results(results))
      end
    end
  end
end
