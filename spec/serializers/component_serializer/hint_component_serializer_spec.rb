require_relative '../../rails_helper'

describe ComponentSerializer::HintComponentSerializer do
  context '#to_h' do
    it 'returns a hash containing the name and data' do
      serializer = described_class.new(content: 'content')

      expected = get_fixture('fixture')

      expect(serializer.to_yaml).to eq expected
    end
  end
end