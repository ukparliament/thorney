require_relative '../../rails_helper'

RSpec.describe ComponentSerializer::HeadingComponentSerializer do
  let(:content) { 'Dianne Abbott' }

  context '#to_h' do
    context 'with just content' do
      it 'returns a hash containing the name and data' do
        serializer = described_class.new(content: content, size: 1)

        expected = get_fixture('only_content')

        expect(serializer.to_yaml).to eq expected
      end
    end

    context 'with link' do
      it 'returns a hash containing the name and data' do
        serializer = described_class.new(content: content, link: 'parliament.uk', size: 1)

        expected = get_fixture('with_link')

        expect(serializer.to_yaml).to eq expected
      end
    end

    context 'with content and data' do
      it 'returns a hash containing the name and data' do
        serializer = described_class.new(
          content: ContentDataHelper.content_data(content: 'translation_key', backend_data: 'Information from the backend'),
          size: 1
        )

        expected = get_fixture('content_and_data')

        expect(serializer.to_yaml).to eq expected
      end
    end

    context 'with content, data and link' do
      it 'returns a hash containing the name and data' do
        serializer = described_class.new(
          content: ContentDataHelper.content_data(content: 'translation_key', backend_data: 'Information from the backend'),
          link: 'parliament.uk',
          size: 1
        )

        expected = get_fixture('content_data_link')

        expect(serializer.to_yaml).to eq expected
      end
    end
  end
end
