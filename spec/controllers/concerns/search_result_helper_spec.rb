require_relative '../../rails_helper'

RSpec.describe SearchResultHelper, type: :helper do
  include SerializerFixtureHelper

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

  describe '#create_search_results' do
    it 'creates the correct search result cards' do
      expected = get_fixture('fixture')

      expect(SearchResultHelper.create_search_results(results).to_yaml).to eq expected
    end
  end
end