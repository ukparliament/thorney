require_relative '../../rails_helper'

RSpec.describe PageSerializer::ListPageSerializer do
  let(:subject) { described_class.new(page_title: 'Test page') }

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

  context '#section_primary_components' do
    it 'calls the correct components' do
      allow(ComponentSerializer::Heading1ComponentSerializer).to receive(:new)

      subject.send(:section_primary_components)

      expect(ComponentSerializer::Heading1ComponentSerializer).to have_received(:new).with(heading_content: 'Test page')
    end
  end


  context '#section_components' do
    it 'calls the correct components' do
      allow(ComponentSerializer::ListComponentSerializer).to receive(:new)
      allow(subject).to receive(:list_components).and_return([])

      subject.send(:section_components)

      expect(ComponentSerializer::ListComponentSerializer).to have_received(:new).with(display: 'generic', display_data: [{:component => 'list', :variant => 'block' }], components: [])
    end
  end

  context 'raising errors' do
    it '#list_components' do
      expect{ subject.send(:list_components) }.to raise_error StandardError, 'You must implement #list_components'
    end
  end
end
