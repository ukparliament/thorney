require_relative '../../rails_helper'

RSpec.describe PageSerializer::GroupsShowPageSerializer do
  include_context "sample request", include_shared: true

  let(:group) do
    double('group',
           groupName: 'Group Test',
           groupStartDate: '12/12/12',
           groupEndDate: '12/12/13'
    )
  end

  let(:subject) { described_class.new(request: request, group: group) }

  context '#to_h' do
    it 'produces the expected JSON hash' do

      expected = get_fixture('fixture')

      expect(subject.to_yaml).to eq expected
    end
  end

  context 'partial data' do
    let(:group_missing_data) do
      double('group',
             groupName: 'Group Test',
             groupStartDate: nil
      )
    end

    it 'produces the expected JSON hash with missing data' do
      serializer = described_class.new(request: request, group: group_missing_data)

      expected = get_fixture('group_missing_data')

      expect(serializer.to_yaml).to eq expected
    end
  end
end
