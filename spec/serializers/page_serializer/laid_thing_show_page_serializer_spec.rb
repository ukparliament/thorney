require_relative '../../rails_helper'

RSpec.describe PageSerializer::LaidThingShowPageSerializer do
  let(:laying_body) { double('laying_body', name: 'LayingBodyTest', graph_id: 'E1234567') }
  let(:laying_person) { double('laying_person', display_name: 'LayingPersonTest', graph_id: 'F1234567') }
  let(:laying) { double('laying', body: laying_body, person: laying_person, date: DateTime.new(2018, 8, 10, 0, 0), graph_id: 'G1234567') }
  let(:procedure) { double('procedure', name: 'ProcedureTest', graph_id: 'D1234567') }
  let(:work_package) { double('work_package', name: 'WorkPackageTest', graph_id: 'C1234567', procedure: procedure) }

  let(:laid_thing) do
    double('laid_thing',
           web_link: 'http://example.com',
           laying: laying,
           work_package: work_package
    )
  end

  let(:subject) { described_class.new(laid_thing: laid_thing) }

  context '#to_h' do
    it 'produces the expected JSON hash' do
create_fixture(subject, 'fixture')
      expected = get_fixture('fixture')

      expect(subject.to_yaml).to eq expected
    end
  end

  context 'partial data' do
    let(:laid_thing_missing_data) do
      double('laid_thing_missing_data',
             web_link: '',
             laying: nil,
             work_package: nil
      )
    end

    it 'produces the expected JSON hash with missing data' do
      serializer = described_class.new(laid_thing: laid_thing_missing_data)

      expected = get_fixture('laid_thing_missing_data')

      expect(serializer.to_yaml).to eq expected
    end
  end
end

