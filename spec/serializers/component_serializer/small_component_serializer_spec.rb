require_relative '../../rails_helper'

RSpec.describe ComponentSerializer::SmallComponentSerializer do
  context '#to_h' do
    context 'with content and additional data' do
      it 'returns a hash containing the content and data' do
        serializer = described_class.new({ bar: '/bar', content: 'Foo' })

        expected = get_fixture('fixture_with_additional_data')

        expect(serializer.to_yaml).to eq expected
      end
    end

    context 'with only content' do
      it 'returns a hash containing the content' do
        serializer = described_class.new({ content: 'Foo' })

        expected = get_fixture('fixture_with_content_only')

        expect(serializer.to_yaml).to eq expected
      end
    end
  end
end
