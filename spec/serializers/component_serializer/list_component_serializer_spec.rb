require_relative '../../rails_helper'

describe ComponentSerializer::ListComponentSerializer do
  context '#to_h' do
    context 'generic' do
      context 'returns a hash containing the name and data' do
        it 'when contents is specified' do
          serializer = described_class.new(display: 'generic', contents: [1, { content: 2, link: 'link' }, 3])

          expected = get_fixture('generic')

          expect(serializer.to_yaml).to eq expected
        end

        it 'when type and components are specified' do
          serializer = described_class.new(display: 'generic', components: [1, 2, 3], type: ComponentSerializer::ListComponentSerializer::Type::UNORDERED)

          expected = get_fixture('type_components')

          expect(serializer.to_yaml).to eq expected
        end

        it 'when display_data is specified' do
          serializer = described_class.new(display_data: 123)

          expected = get_fixture('display_data')

          expect(serializer.to_yaml).to eq expected
        end
      end
    end
  end
end