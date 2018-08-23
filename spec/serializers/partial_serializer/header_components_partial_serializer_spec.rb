require_relative '../../rails_helper'

RSpec.describe PartialSerializer::HeaderComponentsPartialSerializer do
  context '#to_h' do
    it 'returns a hash containing the name and data' do

      expected = get_fixture('fixture')

      expect(subject.to_yaml).to eq expected
    end

    it 'when global search is not included it returns a hash containing the name and data but not global search' do
      serializer = described_class.new(include_global_search: false)

      expected = get_fixture('no_global')

      expect(serializer.to_yaml).to eq expected
    end

  end
end
