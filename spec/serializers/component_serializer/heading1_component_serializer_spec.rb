require_relative '../../rails_helper'

describe ComponentSerializer::Heading1ComponentSerializer do
  let(:heading_content) { 'Dianne Abbott' }
  let(:heading_data) { 'www.dianneabbott.com' }
  let(:subheading_content) { 'MP for' }
  let(:subheading_data) { 'www.MP.com' }
  let(:context_content) { 'Ingelbert and Humperdink' }
  let(:context_data) { 'www.londonborughofingelbertandhumperdink.com' }
  let(:context_hidden) { true }

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

      context 'with subheading, heading and context content' do
        it 'returns a hash containing the name and data' do
          serializer = described_class.new(heading_content: heading_content, subheading_content: subheading_content, context_content: context_content)

          expected = get_fixture('all_content')

          expect(serializer.to_yaml).to eq expected
        end
      end

      context 'with all content and heading data' do
        it 'returns a hash containing the name and data' do
          serializer = described_class.new(heading_content: heading_content, heading_data: heading_data, subheading_content: subheading_content, context_content: context_content)

          expected = get_fixture('all_content_heading_data')

          expect(serializer.to_yaml).to eq expected
        end
      end

      context 'with all content and heading, subheading data' do
        it 'returns a hash containing the name and data' do
          serializer = described_class.new(heading_content: heading_content, heading_data: heading_data, subheading_content: subheading_content, subheading_data: subheading_data, context_content: context_content)

          expected = get_fixture('all_content_heading_subheading_data')

          expect(serializer.to_yaml).to eq expected
        end
      end

      context 'with all content and all data' do
        it 'returns a hash containing the name and data' do
          serializer = described_class.new(heading_content: heading_content, heading_data: heading_data, subheading_content: subheading_content, subheading_data: subheading_data, context_content: context_content, context_data: context_data)

          expected = get_fixture('all_content_all_data')

          expect(serializer.to_yaml).to eq expected
        end
      end

      context 'with all content and all data and context hidden' do
        it 'returns a hash containing the name and data' do
          serializer = described_class.new(heading_content: heading_content, heading_data: heading_data, subheading_content: subheading_content, subheading_data: subheading_data, context_content: context_content, context_data: context_data, context_hidden: context_hidden)

          expected = get_fixture('all_content_all_data_context_hidden')

          expect(serializer.to_yaml).to eq expected
        end
      end

  end
end
