require_relative '../../rails_helper'

describe ComponentSerializer::HeadingComponentSerializer do
  let(:content) { ['Dianne Abbott'] }
  let(:translation_key) { 'search.about-count' }
  let(:translation_data) { { count: 123 } }

  context '#to_h' do
    context 'with just content' do
      it 'returns a hash containing the name and data' do
        serializer = described_class.new(content: content, size: 1)

        expected = get_fixture('only_content')

        expect(serializer.to_yaml).to eq expected
      end
    end

    context 'with just a translation' do
      it 'returns a hash containing the name and data' do
        serializer = described_class.new(
            translation_key: translation_key,
            translation_data: translation_data,
            size: 1
        )

        expected = get_fixture('only_translation')

        expect(serializer.to_yaml).to eq expected
      end
    end

    context 'with content and translation' do
      it 'returns a hash containing the name and data' do
        serializer = described_class.new(
            content: content,
            translation_key: translation_key,
            translation_data: translation_data,
            size: 1
        )

        expected = get_fixture('content_and_translation')

        expect(serializer.to_yaml).to eq expected
      end
    end
  end
end