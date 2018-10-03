require_relative '../../../rails_helper'

RSpec.describe PageSerializer::SearchPage::LandingPageSerializer do
  include_context "sample request", :include_shared => true

  context '#to_h' do
    context 'without a query' do
      it 'produces the correct hash' do

        expected = get_fixture('without_query')

        expect(subject.to_yaml).to eq expected
      end
    end

    context 'with a flash message' do
      it 'produces the correct hash' do
        serializer = described_class.new(request: request, flash_message: 'some flash message')

        expected = get_fixture('with_flash_message')

        expect(serializer.to_yaml).to eq expected
      end
    end
  end

  context 'the serializers are correctly called' do
    context 'without a query' do
      it '#content' do
        allow(ComponentSerializer::SectionComponentSerializer).to receive(:new)

        allow(subject).to receive(:section_primary_components) { [] }

        subject.to_h

        expect(ComponentSerializer::SectionComponentSerializer).to have_received(:new).with(components: [], type: 'primary', content_flag: true)
      end
    end

    context 'with a flash message' do
      it '#content' do
        serializer = described_class.new(request: request, flash_message: 'some flash message')

        allow(ComponentSerializer::SectionComponentSerializer).to receive(:new)

        allow(serializer).to receive(:section_primary_components) { [] }
        allow(serializer).to receive(:flash_message_display_data) { 'flash_message_display_data' }
        allow(serializer).to receive(:flash_message_paragraph) { 'flash_message_paragraph' }

        serializer.to_h

        expect(ComponentSerializer::SectionComponentSerializer).to have_received(:new).with(components: [], type: 'primary')
        expect(ComponentSerializer::SectionComponentSerializer).to have_received(:new).with(components: [ComponentSerializer::StatusComponentSerializer.new(type: 'highlight', display_data: 'flash_message_display_data', components: ['flash_message_paragraph']).to_h], content_flag: true)
      end
    end
  end
end
