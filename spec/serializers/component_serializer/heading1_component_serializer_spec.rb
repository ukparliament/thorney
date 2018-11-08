require_relative '../../rails_helper'

RSpec.describe ComponentSerializer::Heading1ComponentSerializer do
  let(:heading) { ContentDataHelper.content_data(content: 'Dianne Abbott', link: 'www.dianneabbott.com') }
  let(:subheading) { ContentDataHelper.content_data(content: 'MP for', link: 'www.MP.com') }
  let(:subheading_link) { '/people/12345678' }
  let(:context) { ContentDataHelper.content_data(content: 'Ingelbert and Humperdink', link: 'londonbouroughofingelbertandhumperdink.com') }
  let(:context_hidden) { true }

  context '#to_h' do
    context 'with just heading content' do
      it 'returns a hash containing the name and data' do
        serializer = described_class.new(heading: 'Dianne Abbott')

        expected = get_fixture('only_heading_content')

        expect(serializer.to_yaml).to eq expected
      end
    end

    context 'with just subheading content' do
      it 'returns a hash containing the name and data' do
        serializer = described_class.new(subheading: 'MP for')

        expected = get_fixture('only_subheading_content')

        expect(serializer.to_yaml).to eq expected
      end
    end

    context 'with just context content' do
      it 'returns a hash containing the name and data' do
        serializer = described_class.new(context: 'Ingelbert and Humperdink')

        expected = get_fixture('only_context_content')

        expect(serializer.to_yaml).to eq expected
      end
    end

    context 'with subheading, heading and context content' do
      it 'returns a hash containing the name and data' do
        serializer = described_class.new(heading: 'Dianne Abbott', subheading: 'MP for', context: 'Ingelbert and Humperdink')

        expected = get_fixture('all_content')

        expect(serializer.to_yaml).to eq expected
      end
    end

    context 'with all content and heading data' do
      it 'returns a hash containing the name and data' do
        serializer = described_class.new(heading: heading, subheading: 'MP for', context: 'Ingelbert and Humperdink')

        expected = get_fixture('all_content_heading_data')

        expect(serializer.to_yaml).to eq expected
      end
    end

    context 'with all content and heading, subheading data' do
      it 'returns a hash containing the name and data' do
        serializer = described_class.new(heading: heading, subheading: subheading, context: 'Ingelbert and Humperdink')

        expected = get_fixture('all_content_heading_subheading_data')

        expect(serializer.to_yaml).to eq expected
      end
    end

    context 'with all content and all data' do
      it 'returns a hash containing the name and data' do
        serializer = described_class.new(heading: heading, subheading: subheading, context: context)

        expected = get_fixture('all_content_all_data')

        expect(serializer.to_yaml).to eq expected
      end
    end

    context 'with all content and all data and context hidden' do
      it 'returns a hash containing the name and data' do
        serializer = described_class.new(heading: heading, subheading: subheading, context: context, context_hidden: context_hidden)

        expected = get_fixture('all_content_all_data_context_hidden')

        expect(serializer.to_yaml).to eq expected
      end
    end

    context 'with a subheading link' do
      context 'when there is subheading_content and subheading_link' do
        it 'wraps subheading_content in an href with a link' do
          serializer = described_class.new(subheading: 'MP for', subheading_link: subheading_link)

          expected = get_fixture('subheading_link')

          expect(serializer.to_yaml).to eq expected
        end
      end

      context 'when there is no subheading_link' do
        it 'does not modify subheading_content' do
          serializer = described_class.new(subheading: 'MP for' )

          expected = get_fixture('no_subheading_link')

          expect(serializer.to_yaml).to eq expected
        end
      end
    end
  end

  context '#to_s' do
    context 'with no subheading content' do
      it 'returns only the heading content' do
        serializer = described_class.new(heading: 'I am a heading')

        expect(serializer.to_s).to eq 'I am a heading'
      end
    end

    context 'with subheading content' do
      it 'returns the subheading content and heading content with a hyphen in between' do
        serializer = described_class.new(heading: 'I am a heading', subheading: 'I am a subheading')

        expect(serializer.to_s).to eq 'I am a heading'
      end
    end

    context 'with no heading content' do
      it 'returns [Name unavailable]' do
        serializer = described_class.new

        expect(serializer.to_s).to eq '[Name unavailable]'
      end
    end
  end
end
