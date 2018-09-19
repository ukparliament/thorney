require_relative '../../rails_helper'

RSpec.describe ComponentSerializer::CardComponentSerializer do
  context '#to_h' do
    it 'returns a hash containing the name and data' do
      serializer = described_class.new(name:'some_card', data: 'some_data')

      expected = get_fixture('fixture')

      expect(serializer.to_yaml).to eq expected
    end
  end
end
