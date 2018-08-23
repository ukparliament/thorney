require_relative '../../rails_helper'

RSpec.describe ComponentSerializer::SectionComponentSerializer do
  let ( :components ) { [1, 2] }

  context '#to_h' do
    context 'a section__section' do
      it 'if content_flag is true' do
        serializer = described_class.new(components, content_flag: true)

        expected = get_fixture('fixture')

        expect(serializer.to_yaml).to eq expected
      end

      it 'if content_flag is not provided' do
        serializer = described_class.new(components)

        expected = get_fixture('no_content_flag')

        expect(serializer.to_yaml).to eq expected
      end

      it 'if display data is provided' do
        serializer = described_class.new(components, display_data: 123 )

        expected = get_fixture('display_data')

        expect(serializer.to_yaml).to eq expected
      end
    end

    context 'a section__primary' do
      it 'if content_flag is true' do
        serializer = described_class.new(components, type: 'primary', content_flag: true)

        expected = get_fixture('primary')

        expect(serializer.to_yaml).to eq expected
      end

      it 'if content_flag is not provided' do
        serializer = described_class.new(components, type: 'primary')

        expected = get_fixture('primary_no_content_flag')

        expect(serializer.to_yaml).to eq expected
      end
    end
  end
end
