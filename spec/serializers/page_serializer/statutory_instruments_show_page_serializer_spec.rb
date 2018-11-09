require_relative '../../rails_helper'

RSpec.describe PageSerializer::StatutoryInstrumentsShowPageSerializer, vcr: true do
  include_context "sample request", include_shared: true

  let(:response) { Parliament::Request::UrlRequest.new(base_url:   ENV['PARLIAMENT_BASE_URL'],
                                                      builder:    Parliament::Builder::NTripleResponseBuilder,
                                                      decorators: Parliament::Grom::Decorator).statutory_instrument_by_id.get }

  let(:statutory_instrument) { response.filter('https://id.parliament.uk/schema/StatutoryInstrumentPaper').first }

  subject { described_class.new(request: request, statutory_instrument: statutory_instrument) }

  context '#to_h' do
    it 'produces the expected JSON hash' do

      expected = get_fixture('fixture')

      expect(subject.to_yaml).to eq expected
    end
  end

  context 'partial data' do
    it 'produces the expected JSON hash with missing data' do

      expected = get_fixture('si_missing_data')

      expect(subject.to_yaml).to eq expected
    end
  end
end
