require_relative '../../rails_helper'

RSpec.describe PageSerializer::LaidThingShowPageSerializer, vcr: true do
  include_context "sample request", include_shared: true

  let(:response) {Parliament::Request::UrlRequest.new(base_url:   'http://localhost:3030/api/v1',
                                                      builder:    Parliament::Builder::NTripleResponseBuilder,
                                                      decorators: Parliament::Grom::Decorator).statutory_instrument_by_id.get}

  let(:laid_thing) {response.filter('https://id.parliament.uk/schema/StatutoryInstrumentPaper').first}

  subject { described_class.new(request: request, laid_thing: laid_thing) }

  context '#heading1_component' do
    it 'raises an error' do
      expect { subject.send(:heading1_component) }.to raise_error('You must implement #heading1_component')
    end
  end

  context '#meta_info' do
    it 'raises an error' do
      expect { subject.send(:meta_info) }.to raise_error('You must implement #meta_info')
    end
  end

  context '#content' do
    it 'calls the correct serializers' do
      allow(subject).to receive(:heading1_component)
      allow(subject).to receive(:meta_info)

      allow(ComponentSerializer::SectionComponentSerializer).to receive(:new)

      subject.send(:content)

      expect(ComponentSerializer::SectionComponentSerializer).to have_received(:new).twice
    end
  end

  context '#section_primary_components' do
    it 'calls the correct serializers' do
      allow(subject).to receive(:heading1_component)
      allow(subject).to receive(:meta_info)

      allow(ComponentSerializer::ListDescriptionComponentSerializer).to receive(:new)

      subject.send(:content)

      expect(ComponentSerializer::ListDescriptionComponentSerializer).to have_received(:new)
    end
  end

  context '#work_package_section' do
    it 'calls the correct serializers' do
      allow(subject).to receive(:heading1_component)
      allow(subject).to receive(:meta_info)

      allow(ComponentSerializer::ListComponentSerializer).to receive(:new)
      allow(ComponentSerializer::CardComponentSerializer).to receive(:new)
      allow(ComponentSerializer::HeadingComponentSerializer).to receive(:new)
      allow(ComponentSerializer::ParagraphComponentSerializer).to receive(:new)

      subject.send(:content)

      expect(ComponentSerializer::ListComponentSerializer).to have_received(:new)
      expect(ComponentSerializer::CardComponentSerializer).to have_received(:new)
      expect(ComponentSerializer::HeadingComponentSerializer).to have_received(:new)
      expect(ComponentSerializer::ParagraphComponentSerializer).to have_received(:new)
    end
  end
end

