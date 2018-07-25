require_relative '../../rails_helper'

RSpec.describe PartialSerializer::HeaderComponentsPartialSerializer do
  context '#to_h' do
    it 'returns a hash containing the name and data' do
      expected = get_fixture('fixture')

      expect(subject.to_yaml).to eq expected
    end
  end
end