require_relative '../../rails_helper'

describe ComponentSerializer::HeadingComponentSerializer do
  let(:heading) { ['Dianne Abbott'] }
  let(:translation_key) { 'search.about-count' }
  let(:translation_data) { { count: 123 } }

  context '#to_h' do
    context 'with just a heading' do
      it 'returns a hash containing the name and data' do
        serializer = described_class.new(heading: heading, size: 1)

        expected = get_fixture('only_heading')

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

    context 'with a heading and translation' do
      it 'returns a hash containing the name and data' do
        serializer = described_class.new(
            heading: heading,
            translation_key: translation_key,
            translation_data: translation_data,
            size: 1
        )

        expected = get_fixture('heading_and_translation')

        expect(serializer.to_yaml).to eq expected
      end
    end
  end
end