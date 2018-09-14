require_relative '../../rails_helper'

RSpec.describe PageSerializer::StatutoryInstrumentsIndexPageSerializer do
  let(:statutory_instrument_a) { double('statutory_instrument_a', name: 'SI Paper A', graph_id: 'A1234567') }
  let(:statutory_instrument_b) { double('statutory_instrument_b', name: 'SI Paper B', graph_id: 'B1234567') }
  let(:statutory_instruments) { [statutory_instrument_a, statutory_instrument_b] }

  let(:subject) { described_class.new(statutory_instruments: statutory_instruments) }

  context '#to_h' do
    it 'produces the expected JSON hash' do
      expected = get_fixture('fixture')

      expect(subject.to_yaml).to eq expected
    end
  end

  context 'the serializers are correctly called' do
    context '#content' do
      before(:each) do
        allow(ComponentSerializer::SectionComponentSerializer).to receive(:new)

        allow(subject).to receive(:section_primary_components) { [] }
        allow(subject).to receive(:section_components) { [] }
      end

      it 'receives the correct serializers' do
        subject.to_h

        expect(ComponentSerializer::SectionComponentSerializer).to have_received(:new).with([], type: 'primary')
        expect(ComponentSerializer::SectionComponentSerializer).to have_received(:new).with([], type: 'section')
      end
    end
  end
end
