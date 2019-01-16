require_relative '../../rails_helper'

RSpec.describe HousesHelper, vcr: true do
  let(:house_request)   { FilterHelper.filter(ParliamentHelper.parliament_request.house_index, 'House') }
  let(:commons)         { house_request[0] }
  let(:lords)           { house_request[1] }
  let(:commons_house_id){ '1AFu55Hs' }
  let(:lords_house_id)  { 'WkUWUBMx' }

  before(:each) do
    described_class.instance_variable_set(:@commons_id, commons_house_id)
    described_class.instance_variable_set(:@lords_id, lords_house_id)
  end

  context '.commons?' do
    context 'commons' do
      it 'will return true' do
        expect(described_class.commons?(commons)).to eq(true)
      end
    end

    context 'not commons' do
      it 'will return false' do
        expect(described_class.commons?(lords)).to eq(false)
      end
    end

    context 'nil' do
      it 'will return false' do
        expect(described_class.commons?(nil)).to eq(false)
      end
    end
  end

  context '.lords?' do
    context 'lords' do
      it 'will return true' do
        expect(described_class.lords?(lords)).to eq(true)
      end
    end

    context 'not lords' do
      it 'will return false' do
        expect(described_class.lords?(commons)).to eq(false)
      end
    end

    context 'nil' do
      it 'will return false' do
        expect(described_class.lords?(nil)).to eq(false)
      end
    end
  end

  context '.commons_id' do
    it 'will return the ID' do
      expect(described_class.commons_id).to eq(commons_house_id)
    end
  end

  context '.lords_id' do
    it 'will return the ID' do
      expect(described_class.lords_id).to eq(lords_house_id)
    end
  end

  context '.house_id_string' do
    context 'commons returned first' do
      it 'will be in the correct order' do
        expect(described_class.house_id_string(commons)).to eq([commons_house_id, lords_house_id])
      end
    end

   context 'lords returned first' do
      it 'will be in the correct order' do
        expect(described_class.house_id_string(lords)).to eq([lords_house_id, commons_house_id])
      end
    end
  end

  context '.person_type_string' do
    context 'commons' do
      it 'will current person type first' do
        expect(described_class.person_type_string(commons)).to eq(['MPs', 'Lords'])
      end
    end

    context 'lords' do
      it 'will current person type first' do
        expect(described_class.person_type_string(lords)).to eq(['Lords', 'MPs'])
      end
    end
  end

  context '.set_ids' do
    before(:each) do
      described_class.instance_variable_set(:@commons_id, nil)
      described_class.instance_variable_set(:@lords_id, nil)
    end

    context '@commons_id and @lords_id already set' do
      it 'will return IDs without making a request' do
        described_class.instance_variable_set(:@commons_id, commons_house_id)
        described_class.instance_variable_set(:@lords_id, lords_house_id)

        described_class.send(:set_ids)

        expect(ParliamentHelper).to_not receive(:parliament_request)
      end
    end

    it 'will set commons and lords instance variables' do
      described_class.send(:set_ids)
      expect(described_class.instance_variable_get(:@commons_id)).to eq(commons_house_id)
      expect(described_class.instance_variable_get(:@lords_id)).to eq(lords_house_id)
    end
  end
end
