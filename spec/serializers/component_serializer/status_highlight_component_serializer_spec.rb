require_relative '../../rails_helper'

describe ComponentSerializer::StatusHighlightComponentSerializer do
  let(:status_highlight_component_serializer) { described_class.new([1, 2]) }

  context '#to_h' do
    it 'returns a hash containing the name and data' do
      expected = get_fixture('fixture')

      expect(status_highlight_component_serializer.to_yaml).to eq expected
    end
  end
end