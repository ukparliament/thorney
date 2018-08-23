require_relative '../../rails_helper'

RSpec.describe ComponentSerializer::LinkButtonComponentSerializer do
  context '#to_h' do
    it 'returns a hash containing the name and data' do
      serializer = described_class.new(link: '/mps', text: 'MPs')

      expected = get_fixture('fixture')

      expect(serializer.to_yaml).to eq expected
    end

    it 'when given a download true argument returns a hash containing the name and data' do
      serializer = described_class.new(link: '/mps', text: 'MPs', download: true)

      expected = get_fixture('with_download')

      expect(serializer.to_yaml).to eq expected
    end

    it 'when given a display_data argument returns a hash containing the name and data' do
      serializer = described_class.new(link: '/mps', text: 'MPs', download: true, display_data: 'display_data')
create_fixture(serializer, 'with_display_data')
      expected = get_fixture('with_display_data')

      expect(serializer.to_yaml).to eq expected
    end
  end
end
