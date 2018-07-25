require_relative '../../rails_helper'

RSpec.describe ComponentSerializer::SearchFormComponentSerializer do
  context '#to_h' do
    it 'it produces the correct hash' do
      serializer = described_class.new(nil, [1])

      expected = get_fixture('fixture')

      expect(serializer.to_yaml).to eq expected
    end

    it 'with a value' do
      serializer = described_class.new('query', [1])

      expected = get_fixture('with_value')

      expect(serializer.to_yaml).to eq expected
    end
  end
end