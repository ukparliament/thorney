require_relative '../../rails_helper'

RSpec.describe PageSerializer::ProposedNegativeStatutoryInstrumentsIndexPageSerializer do
  let(:statutory_instrument_a) { double('statutory_instrument_a', name: 'SI Paper A', graph_id: 'A1234567') }
  let(:statutory_instrument_b) { double('statutory_instrument_b', name: 'SI Paper B', graph_id: 'B1234567') }
  let(:statutory_instruments) { [statutory_instrument_a, statutory_instrument_b] }

  let(:subject) { described_class.new(proposed_negative_statutory_instruments: statutory_instruments) }

  context '#to_h' do
    it 'produces the expected JSON hash' do

      expected = get_fixture('fixture')

      expect(subject.to_yaml).to eq expected
    end
  end
end
