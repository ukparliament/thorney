require_relative '../../rails_helper'

RSpec.describe PageSerializer::LayingsShowPageSerializer, vcr: true do
  include_context 'sample request', include_shared: true

  let(:response) do
    Parliament::Request::UrlRequest.new(base_url:   ENV['PARLIAMENT_BASE_URL'],
                                        builder:    Parliament::Builder::NTripleResponseBuilder,
                                        decorators: Parliament::Grom::Decorator).laid_paper_by_id.get
  end

  let(:laying) { response.filter('https://id.parliament.uk/schema/Laying').first }

  subject { described_class.new(request: request, laying: laying) }

  context '#to_h' do
    it 'produces the expected JSON hash' do

      expected = get_fixture('fixture')

      expect(subject.to_yaml).to eq expected
    end
  end

  context '#to_h' do
    it 'with a PNSI produces the expected JSON hash' do

      expected = get_fixture('PNSI_fixture')

      expect(subject.to_yaml).to eq expected
    end
  end

  context 'with no name' do
    it 'produces the expected JSON hash with no name' do

      expected = get_fixture('group_with_no_name')

      expect(subject.to_yaml).to eq expected
    end
  end


  context 'partial data' do
    it 'produces the expected JSON hash with missing data' do

      expected = get_fixture('procedure_missing_data')

      expect(subject.to_yaml).to eq expected
    end
  end
end
