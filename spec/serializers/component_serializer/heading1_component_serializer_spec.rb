require_relative '../../rails_helper'

describe ComponentSerializer::Heading1ComponentSerializer do
  let(:heading_content) { 'Dianne Abbott' }
  let(:heading_data) { 'www.dianneabbott.com' }
  let(:subheading_content) { 'MP for' }
  let(:subheading_data) { 'www.MP.com' }
  let(:context_content) { 'Ingelbert and Humperdink' }
  let(:context_data) { 'www.londonborughofingelbertandhumperdink.com' }
  let(:context_hidden) { false }

  context '#to_h' do
    context 'with just heading content' do
      it 'returns a hash containing the name and data' do
        serializer = described_class.new(heading_content: heading_content)

        expected = get_fixture('only_heading_content')

        expect(serializer.to_yaml).to eq expected
      end
    end

      context 'with just subheading content' do
        it 'returns a hash containing the name and data' do
          serializer = described_class.new(subheading_content: subheading_content)

          expected = get_fixture('only_subheading_content')

          expect(serializer.to_yaml).to eq expected
        end
      end

      context 'with just context content' do
        it 'returns a hash containing the name and data' do
          serializer = described_class.new(context_content: context_content)

          expected = get_fixture('only_context_content')

          expect(serializer.to_yaml).to eq expected
        end
      end


  end
end
