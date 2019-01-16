require_relative '../../rails_helper'

RSpec.describe GroupSortHelper, type: :helper, vcr: true do
# The doubles below used together create a data set on which to test the various methods within the module.
# At the bottom of the file are tests using n-triple data.

  let(:object_one) { double('one', date: DateTime.parse('23/12/2016'), person: person_one) }
  let(:object_two) { double('two', date: DateTime.parse('10/08/2009'), person: person_two) }
  let(:object_three) { double('three', date: DateTime.parse('10/08/2009'), person: person_three) }
  let(:object_four) { double('four', date: DateTime.parse('10/08/2009'), person: person_four) }
  let(:object_five) { double('five', person: person_five) }
  let(:object_six) { double('six', date: DateTime.parse('03/01/2018'), person: person_six) }
  let(:object_seven) { double('seven', date: DateTime.parse('03/01/2018')) }
  let(:object_eight) { double('eight', date: DateTime.parse('03/01/2018'), person: person_eight) }
  let(:object_nine) { double('nine', date: DateTime.parse('03/01/2018'), person: person_nine) }
  let(:object_ten) { double('ten', person: person_ten) }
  let(:object_eleven) { double('eleven', date: DateTime.parse('10/08/2009'), person: person_eleven) }
  let(:object_twelve) { double('twelve', date: DateTime.parse('10/08/2009'), person: person_twelve) }

  let(:person_one) { double('person_one', name: 'Ann') }
  let(:person_two) { double('person_two', name: 'Ann') }
  let(:person_three) { double('person_three', name: 'Theresa') }
  let(:person_four) { double('person_four', name: 'Hannah') }
  let(:person_five) { double('person_five', name: 'Sally') }
  let(:person_six) { double('person_six', name: 'Ann') }
  let(:person_eight) { double('person_eight', name: 'Theresa') }
  let(:person_nine) { double('person_nine', name: 'Greta') }
  let(:person_ten) { double('person_ten', name: 'Zara') }
  let(:person_eleven) { double('person_eleven', name: 'Greta') }
  let(:person_twelve) { double('person_twelve', name: 'Zara') }

  let(:full_data_objects) { [object_one, object_eight, object_three, object_six, object_two, object_nine, object_eleven, object_four] }
  let(:all_objects) { [object_one, object_ten, object_eight, object_five, object_three, object_six, object_two, object_nine, object_eleven, object_seven, object_four, object_twelve] }

  let(:full_data_hash_by_person) do
    {
      'Ann' => [object_one, object_six, object_two],
      'Greta' => [object_nine, object_eleven],
      'Hannah' => [object_four],
      'Theresa' => [object_eight, object_three]
    }
  end

  let(:all_data_hash_by_person) do
    {
      'Ann' => [object_one, object_six, object_two],
      'Greta' => [object_nine, object_eleven],
      'Hannah' => [object_four],
      'Sally' => [object_five],
      'Theresa' => [object_eight, object_three],
      'Zara' => [object_ten, object_twelve],
      nil => [object_seven]
    }
  end

  let(:full_data_hash_by_date) do
    {
      DateTime.parse('23/12/2016') => [object_one],
      DateTime.parse('10/08/2009') => [object_three, object_two, object_eleven, object_four],
      DateTime.parse('03/01/2018') => [object_eight, object_six, object_nine]
    }
  end

  let(:all_data_hash_by_date) do
    {
      DateTime.parse('23/12/2016') => [object_one],
      DateTime.parse('10/08/2009') => [object_three, object_two, object_eleven, object_four, object_twelve],
      DateTime.parse('03/01/2018') => [object_eight, object_six, object_nine, object_seven],
      nil => [object_ten, object_five]
    }
  end

  let(:block) do
    proc do |object|
      value = object.try(:date)

      next nil if value.nil?

      value
    end
  end

  describe '#group' do
    context 'with no block or method_symbols' do
      it 'returns out of the method' do
        expect(described_class.group(full_data_objects)).to be(nil)
      end
    end

    context 'with a block' do
      context 'full data' do
        it 'returns the data grouped by the given block' do
          expect(described_class.group(full_data_objects, block: block)).to eq(full_data_hash_by_date)
        end
      end

      context 'missing data' do
        it 'returns the data grouped by the given block' do
          expect(described_class.group(all_objects, block: block)).to eq(all_data_hash_by_date)
        end
      end
    end

    context 'with method_symbols' do
      context 'full data' do
        it 'returns the data grouped by the method symbols' do
          expect(described_class.group(full_data_objects, method_symbols: [:person, :name])).to eq(full_data_hash_by_person)
        end
      end

      context 'missing data' do
        it 'returns the data grouped by the method symbols' do
          expect(described_class.group(all_objects, method_symbols: [:person, :name])).to eq(all_data_hash_by_person)
        end
      end
    end
  end

  describe '#sort' do
    context 'with no block or method_symbols' do
      it 'returns out of the method' do
        expect(described_class.sort(full_data_hash_by_person)).to be(nil)
      end
    end

    context 'with a block' do
      context 'full data' do
        it 'returns the data sorted by the given block' do
          expected = [object_two, object_one, object_six, object_eleven, object_nine, object_four, object_three, object_eight]

          expect(described_class.sort(full_data_hash_by_person, block: block)).to eq(expected)
        end
      end

      context 'missing data' do
        it 'returns the data sorted by the given block' do
          expected = [object_two, object_one, object_six, object_eleven, object_nine, object_four, object_five, object_three, object_eight, object_ten, object_twelve, object_seven]

          expect(described_class.sort(all_data_hash_by_person, block: block)).to eq(expected)
        end
      end
    end

    context 'with method_symbols' do
      context 'full data' do
        it 'returns the data sorted by the method symbols' do
          expected = [object_one, object_two, object_eleven, object_four, object_three, object_six, object_nine, object_eight]

          expect(described_class.sort(full_data_hash_by_date, method_symbols: [:person, :name])).to eq(expected)
        end
      end

      context 'missing data' do
        it 'returns the data sorted by the method symbols' do
          expected = [object_one, object_two, object_eleven, object_four, object_three, object_twelve, object_six, object_nine, object_eight, object_seven, object_ten, object_five]

          expect(described_class.sort(all_data_hash_by_date, method_symbols: [:person, :name])).to eq(expected)
        end
      end
    end

    context 'with a direction' do
      it 'returns the data sorted by the method symbols in descending order' do
        expected = [object_one, object_three, object_four, object_eleven, object_two, object_eight, object_nine, object_six]

        expect(described_class.sort(full_data_hash_by_date, method_symbols: [:person, :name], descending: true)).to eq(expected)
      end
    end
  end

  describe '#sort_keys' do
    context 'with a block' do
      context 'full data' do
        it 'returns the data sorted by the given block' do
          hash = { 'c' => 1, 'a' => 2, 'd' => 3, 'b' => 4 }

          expect(described_class.sort_keys(hash)).to eq({ 'a' => 2, 'b' => 4, 'c' => 1, 'd' => 3 })
        end
      end

      context 'missing data' do
        it 'returns the data sorted by the given block' do
          hash = { 'c' => 1, 'a' => 2, nil => 5, 'd' => 3, 'b' => 4 }

          expect(described_class.sort_keys(hash)).to eq({ 'a' => 2, 'b' => 4, 'c' => 1, 'd' => 3, nil => 5 })
        end
      end
    end
  end

  describe '#group_and_sort' do
    it 'returns the data grouped and sorted' do
      expected = [object_six, object_nine, object_eight, object_one, object_two, object_eleven, object_four, object_three]

      expect(described_class.group_and_sort(full_data_objects, group_block: block, key_sort_descending: true, sort_method_symbols: [:person, :name])).to eq(expected)
    end
  end

  context 'with real data' do
    let(:response) { Parliament::Request::UrlRequest.new(base_url:   ENV['PARLIAMENT_BASE_URL'],
                                                        builder:    Parliament::Builder::NTripleResponseBuilder,
                                                        decorators: Parliament::Grom::Decorator).statutory_instrument_index.get }

    let(:statutory_instruments) { response.filter('https://id.parliament.uk/schema/StatutoryInstrumentPaper') }

    let(:grouping_block) do
      proc do |node|
        value = node.try(:laying).try(:date)

        next nil if value.nil?

        value.to_date
      end
    end

    let(:grouped_nodes) { described_class.group(statutory_instruments, block: grouping_block) }

    context '#group' do
      it 'groups the data correctly' do
        expect(grouped_nodes.keys.uniq).to eq(grouped_nodes.keys)
        expect(grouped_nodes.values.first.length).to eq(3)

        grouped_nodes.values.first.each do |node|
          expect(node).to be_a(Grom::Node)
        end
      end
    end

    context '#sort_keys' do
      it 'sorts a hash by its keys correctly' do
        sorted = described_class.sort_keys(grouped_nodes)

        expect(sorted.keys.first).to eq(Date.new(2018, 3, 29))
        expect(sorted.keys[-2]).to eq(Date.new(2018, 10, 16))
        expect(sorted.keys.last).to be(nil)
      end
    end

    context '#sort' do
      it 'sorts the data correctly' do
        sorted = described_class.sort(grouped_nodes, method_symbols: [:statutoryInstrumentPaperName])

        expect(sorted[0].statutoryInstrumentPaperName).to eq('statutoryInstrumentPaperName - 1')
        expect(sorted[0].laying.date).to eq(DateTime.new(2018, 5, 3, 1, 0))

        expect(sorted[1].statutoryInstrumentPaperName).to eq('statutoryInstrumentPaperName - 22')
        expect(sorted[1].laying.date).to eq(DateTime.new(2018, 5, 3, 1, 0))

        expect(sorted[2].statutoryInstrumentPaperName).to eq('statutoryInstrumentPaperName - 6')
        expect(sorted[2].laying.date).to eq(DateTime.new(2018, 5, 3, 1, 0))

        expect(sorted[3].statutoryInstrumentPaperName).to eq('statutoryInstrumentPaperName - 2')
        expect(sorted[3].laying.date).to eq(DateTime.new(2018, 4, 27, 1, 0))

        expect(sorted.last.statutoryInstrumentPaperName).to eq('statutoryInstrumentPaperName - 278')
        expect(sorted.last.try(:laying).try(:date)).to be(nil)
      end
    end
  end
end
