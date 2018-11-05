require_relative '../../rails_helper'

RSpec.describe ComponentSerializer::ParagraphComponentSerializer do
  let(:paragraph_component_serializer) { described_class.new(content: ['one', ContentDataHelper.content_data(content: 'two', link: 'link') ]) }

  context '#to_h' do
    it 'returns a hash containing the name and data' do
      expected = get_fixture('fixture')

      expect(paragraph_component_serializer.to_yaml).to eq expected
    end

    context 'handling any property' do
      it 'returns a hash containing the name and multiple bits of data' do
        serializer = described_class.new(content: [ContentDataHelper.content_data(content: 'some content', one: 'property', yet: 'another')])

        expected = get_fixture('any_property')

        expect(serializer.to_yaml).to eq expected
      end

      it 'returns a hash containing the name and multiple paragraphs with multiple bit of data' do
        serializer = described_class.new(
          content: [
            ContentDataHelper.content_data(content: 'some content', one: 'property', yet: 'another'),
            ContentDataHelper.content_data(content: 'some content', one: 'property', yet: 'another'),
            ContentDataHelper.content_data(content: 'some content', one: 'property', yet: 'another')
            ]
          )

        expected = get_fixture('many_properties')

        expect(serializer.to_yaml).to eq expected
      end
    end
  end
end
