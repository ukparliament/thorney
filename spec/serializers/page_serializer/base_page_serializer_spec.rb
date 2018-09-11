require_relative '../../rails_helper'

RSpec.describe PageSerializer::BasePageSerializer do
  let(:base_page_serializer) { described_class.new }

  context '#opensearch_description_url' do
    it 'raises an error' do
      expect { base_page_serializer.send(:opensearch_description_url) }.to raise_error('You must implement #opensearch_description_url')
    end
  end

  context '#main_components' do
    it 'raises an error' do
      expect { base_page_serializer.send(:main_components) }.to raise_error('You must implement #content')
    end
  end

  context '#hash' do
    it 'calls the correct serializer' do
      allow(base_page_serializer).to receive(:meta)
      allow(base_page_serializer).to receive(:main_components)
      allow(base_page_serializer).to receive(:opensearch_description_url)

      allow(PartialSerializer::HeaderComponentsPartialSerializer).to receive(:new)
      allow(PartialSerializer::FooterComponentsPartialSerializer).to receive(:new)

      base_page_serializer.send(:hash)

      expect(PartialSerializer::HeaderComponentsPartialSerializer).to have_received(:new)
      expect(PartialSerializer::FooterComponentsPartialSerializer).to have_received(:new)
    end
  end
end
