require_relative '../../rails_helper'

describe ComponentSerializer::ParagraphComponentSerializer do
  let(:paragraph_component_serializer) { described_class.new([{ content: 'one' }, { content: 'two', link: 'link' }]) }

  context '#to_h' do
    it 'returns a hash containing the name and data' do
      expected = get_fixture('fixture')

      expect(paragraph_component_serializer.to_yaml).to eq expected
    end
  end
end