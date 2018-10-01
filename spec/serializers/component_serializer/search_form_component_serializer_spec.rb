require_relative '../../rails_helper'

RSpec.describe ComponentSerializer::SearchFormComponentSerializer do
  context '#to_h' do
    it 'it produces the correct hash' do
      serializer = described_class.new(query: nil, components: [1])

      expected = get_fixture('fixture')

      expect(serializer.to_yaml).to eq expected
    end

    it 'with a value' do
      serializer = described_class.new(query: 'query', components: [1])

      expected = get_fixture('with_value')

      expect(serializer.to_yaml).to eq expected
    end

    it 'with a global flag' do
      serializer = described_class.new(query: 'query', components: [1], global: true)

      expected = get_fixture('with_global')

      expect(serializer.to_yaml).to eq expected
    end

    context 'with a search_action passed' do
      it 'returns the expected JSON' do
        serializer = described_class.new(query: 'query', components: [1], search_action: '/foo/search')

        expected = get_fixture('with_search_action')

        expect(serializer.to_yaml).to eq expected
      end
    end
  end
end
