require_relative '../../rails_helper'

RSpec.describe ComponentSerializer::SearchIconComponentSerializer do
  context '#to_h' do
    it 'it produces the correct hash' do
      serializer = described_class.new

      expected = get_fixture('fixture')

      expect(serializer.to_yaml).to eq expected
    end
  end
end