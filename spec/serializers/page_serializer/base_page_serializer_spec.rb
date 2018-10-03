require_relative '../../rails_helper'

RSpec.describe PageSerializer::BasePageSerializer do
  include_context "sample request", :include_shared => true

  let(:base_page_serializer) { described_class.new(request: request) }

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

  context 'with no original url, or a unexpected request' do
    it 'has a nil original_url' do
      expect(described_class.new(request: nil).request_original_url).to be_nil
    end
  end
end
