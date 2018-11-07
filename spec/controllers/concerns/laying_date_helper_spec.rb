require_relative '../../rails_helper'

RSpec.describe LayingDateHelper, type: :helper do
  describe '#get_date' do

    let(:work_package) { double('work_package', work_packaged_thing: work_packaged_thing) }
    let(:work_packaged_thing) { double('work_packaged_thing', laidThingHasLaying: [laying_one, laying_two]) }
    let(:laying_one) { double('laying_one', date: DateTime.new(2018, 11, 8)) }
    let(:laying_two) { double('laying_two', date: DateTime.new(2018, 11, 4)) }

    let(:laying_no_date) { double('laying_one', date: nil) }
    let(:work_package_no_laying_dates) { double('work_package_no_laying_dates', work_packaged_thing: work_packaged_thing_no_laying_date) }
    let(:work_packaged_thing_no_laying_date) { double('work_packaged_thing_no_laying_date', laidThingHasLaying: [laying_no_date, laying_no_date]) }

    let(:work_package_one_laying_date) { double('work_package_one_laying_date', work_packaged_thing: work_packaged_thing_one_laying_date) }
    let(:work_packaged_thing_one_laying_date) { double('work_packaged_thing_one_laying_date', laidThingHasLaying: [laying_no_date, laying_one]) }

    let(:work_package_one_laying) { double('work_package_one_laying', work_packaged_thing: work_packaged_thing_one_laying) }
    let(:work_packaged_thing_one_laying) { double('work_packaged_thing_one_laying', laidThingHasLaying: [laying_one]) }

    let(:work_package_one_laying_no_date) { double('work_package_one_laying', work_packaged_thing: work_packaged_thing_one_laying_no_date) }
    let(:work_packaged_thing_one_laying_no_date) { double('work_packaged_thing_one_laying', laidThingHasLaying: [laying_no_date]) }

    let(:work_package_no_layings) { double('work_package_no_layings', work_packaged_thing: work_packaged_thing_no_layings) }
    let(:work_packaged_thing_no_layings) { double('work_packaged_thing_no_layings') }

    let(:work_package_no_work_packaged_thing) { double('work_package_no_work_packaged_thing', work_packaged_thing: nil) }


    context 'full data' do
      it 'returns the earliest laying date' do
        date = described_class.get_date(work_package)

        expect(date).to eq(DateTime.new(2018, 11, 4))
      end
    end

    context 'two layings' do
      context 'both layings with no date' do
        it 'returns nil' do
          date = described_class.get_date(work_package_no_laying_dates)

          expect(date).to be(nil)
        end
      end

      context 'one laying has no date' do
        it 'returns the other laying date' do
          date = described_class.get_date(work_package_one_laying_date)

          expect(date).to eq(DateTime.new(2018, 11, 8))
        end
      end
    end

    context 'one laying' do
      context 'with date' do
        it 'returns the earliest laying date' do
          date = described_class.get_date(work_package_one_laying)

          expect(date).to eq(DateTime.new(2018, 11, 8))
        end
      end

      context 'with no date' do
        it 'returns nil' do
          date = described_class.get_date(work_package_one_laying_no_date)

          expect(date).to be(nil)
        end
      end
    end

    context 'work_packaged_thing has no layings' do
      it 'returns nil' do
        date = described_class.get_date(work_package_no_layings)

        expect(date).to be(nil)
      end
    end

    context 'work package has no work_packaged_thing' do
      it 'returns nil' do
        date = described_class.get_date(work_package_no_work_packaged_thing)

        expect(date).to be(nil)
      end
    end
  end
end