require_relative '../../rails_helper'

RSpec.describe SortHelper, type: :helper do

  let(:object_four) {double('4', name: 'Bob' )}
  let(:object_three) {double('3', date: DateTime.parse('23/12/2016'))}
  let(:object_two) {double('2', date: DateTime.parse('10/08/2009'))}
  let(:object_one) {double('1', date: DateTime.parse('03/01/2018'))}
  let(:objects) { [object_one, object_two, object_three, object_four] }

  describe '#sort_by' do
    it 'sorts an array by a given attribute' do
      sort_by_example = SortHelper.sort_by(collection: objects, attributes: [:date])

      expect(sort_by_example).to eq([object_two, object_three, object_one, object_four])
    end

    it 'sorts an array by a given attribute and removes entries with out that attribute' do
      sort_by_example = SortHelper.sort_by(collection: objects, attributes: [:date], prepend_rejected: true)

      expect(sort_by_example).to eq([object_four, object_two, object_three, object_one])
    end
  end

  describe '#sort_by_reverse' do
    it 'sorts an array by a given attribute' do
      sort_by_example = SortHelper.sort_by_reverse(collection: objects, attributes: [:date])

      expect(sort_by_example).to eq([object_four, object_one, object_three, object_two])
    end

    it 'sorts an array by a given attribute and removes entries with out that attribute' do
      sort_by_example = SortHelper.sort_by_reverse(collection: objects, attributes: [:date], prepend_rejected: true)

      expect(sort_by_example).to eq([object_one, object_three, object_two, object_four])
    end
  end
end
