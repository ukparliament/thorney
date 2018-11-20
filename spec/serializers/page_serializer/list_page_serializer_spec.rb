require_relative '../../rails_helper'

RSpec.describe PageSerializer::ListPageSerializer do
  include_context "sample request", include_shared: true

  # let(:heading) { double('heading', heading_content: 'Test page', subheading_content: nil, linkify_subheading: nil, to_h: { name: 'heading1', data: { heading: { content: 'Test page' } } }) }
  let(:heading) { double('heading', to_s: 'some meta heading', to_h: { name: 'heading1', data: { heading: { content: 'Test page' } } }) }

  subject { described_class.new(request: request, heading_component: heading, list_components: [{ list_component: 'list component' }]) }

  context 'the serializers are correctly called' do
    context '#content' do
      before(:each) do
        allow(ComponentSerializer::SectionComponentSerializer).to receive(:new)

        allow(subject).to receive(:section_primary_components) { [] }
        allow(subject).to receive(:section_components) { [] }
      end

      it 'receives the correct serializers' do
        subject.to_h

        expect(ComponentSerializer::SectionComponentSerializer).to have_received(:new).with(components: [], type: 'primary')
        expect(ComponentSerializer::SectionComponentSerializer).to have_received(:new).with(components: [], type: 'section')
      end
    end
  end

  context '#meta' do
    it 'calls #to_s on the heading component' do
      meta = subject.send(:meta)

      expect(meta[:title]).to eq 'some meta heading - UK Parliament'
    end
  end

  context '#section_primary_components' do
    it 'calls the correct methods on the heading component' do
      subject.send(:section_primary_components)

      expect(heading).to have_received(:to_h)
    end
  end

  context '#section_components' do
    it 'calls the correct components' do
      allow(ComponentSerializer::ListComponentSerializer).to receive(:new)

      subject.send(:section_components)

      expect(ComponentSerializer::ListComponentSerializer).to have_received(:new).with(display: 'generic', display_data: [{:component => 'list', :variant => 'block' }], :components=>[{:list_component=>"list component"}])
    end
  end

  context 'the JSON is produced correctly' do
    context '#to_h' do
      it 'produces the expected JSON hash' do
        expected = get_fixture('fixture')

        expect(subject.to_yaml).to eq expected
      end

      it 'produces the expected JSON hash when no list items are given' do
        serializer = described_class.new(request: request, heading_component: heading, list_components: [])

        expected = get_fixture('no_list_items')

        expect(serializer.to_yaml).to eq expected
      end
    end
  end
end
