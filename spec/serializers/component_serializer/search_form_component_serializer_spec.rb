require_relative '../../rails_helper'

describe ComponentSerializer::SearchFormComponentSerializer do
  let(:serializer) { described_class.new }

  context '#to_h' do
    it 'it produces the correct hash' do
      expected = get_fixture('fixture')

      expect(serializer.to_yaml).to eq expected
    end

    it 'with a value' do
      serializer = described_class.new('query')

      expected = get_fixture('with_value')

      expect(serializer.to_yaml).to eq expected
    end
  end
end