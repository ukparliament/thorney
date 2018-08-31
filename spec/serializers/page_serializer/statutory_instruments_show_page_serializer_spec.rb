require_relative '../../rails_helper'

RSpec.describe PageSerializer::StatutoryInstrumentsShowPageSerializer do
  let(:laying_body) { double('laying_body', name: 'LayingBodyTest', graph_id: 'E1234567') }
  let(:laying_person) { double('laying_person', display_name: 'LayingPersonTest', graph_id: 'F1234567') }
  let(:laying) { double('laying', body: laying_body, person: laying_person) }
  let(:procedure) { double('procedure', name: 'ProcedureTest', graph_id: 'D1234567') }
  let(:work_package) { double('work_package', name: 'WorkPackageTest', graph_id: 'C1234567', procedure: procedure) }
  let(:proposed_neg_stat_instrument_a) { double('proposed_neg_stat_instrument_a', name: 'ProposedNegSIPaperA', graph_id: 'A1234567') }
  let(:proposed_neg_stat_instrument_b) { double('proposed_neg_stat_instrument_b', name: 'ProposedNegSIPaperB', graph_id: 'B1234567') }

  let(:statutory_instrument) do
    double('statutory_instrument',
           name: 'SI Paper Test',
           prefix: 'SI',
           year: '2018',
           number: '568',
           coming_into_force_date: DateTime.new(2018, 9, 10, 0, 0),
           coming_into_force_note: 'SI Paper Test Note',
           made_date: DateTime.new(2018, 10, 10, 0, 0),
           web_link: 'http://example.com',
           laying: laying,
           work_package: work_package,
           proposed_negative_statutory_instrument_papers: [proposed_neg_stat_instrument_a, proposed_neg_stat_instrument_b]
    )
  end

  let(:subject) { described_class.new(statutory_instrument: statutory_instrument) }

  context '#to_h' do
    it 'produces the expected JSON hash' do
      create_fixture(subject, 'fixture')
      expected = get_fixture('fixture')

      expect(subject.to_yaml).to eq expected
    end
  end

  context 'partial data' do
    let(:si_missing_data) do
      double('si_missing_data',
             name: 'SI Paper Test',
             prefix: 'SI',
             year: '2018',
             number: '568',
             coming_into_force_date: nil,
             coming_into_force_note: 'SI Paper Test Note',
             made_date: nil,
             web_link: '',
             laying: nil,
             work_package: nil,
             proposed_negative_statutory_instrument_papers: []
      )
    end

    it 'produces the expected JSON hash with missing data' do
      serializer = described_class.new(statutory_instrument: si_missing_data)

      # create_fixture(serializer, 'si_missing_data')
      expected = get_fixture('si_missing_data')

      expect(serializer.to_yaml).to eq expected
    end
  end

  context 'the section serializers are correctly called' do
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

