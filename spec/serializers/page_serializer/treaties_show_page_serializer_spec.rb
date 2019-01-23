require_relative '../../rails_helper'

RSpec.describe PageSerializer::TreatiesShowPageSerializer, vcr: true do
  include_context "sample request", include_shared: true

  let(:response) { Parliament::Request::UrlRequest.new(base_url:   ENV['PARLIAMENT_BASE_URL'],
                                                      builder:    Parliament::Builder::NTripleResponseBuilder,
                                                      decorators: Parliament::Grom::Decorator).treaty_by_id.set_url_params({ treaty_id: 'gzoa2qc8' }).get }

  let(:treaty) {response.filter('https://id.parliament.uk/schema/Treaty').first}

  subject { described_class.new(request: request, treaty: treaty) }

  context '#to_h' do
    it 'produces the expected JSON hash' do

      expected = get_fixture('fixture')

      expect(subject.to_yaml).to eq expected
    end
  end

  context 'with no name' do
    it 'produces the expected JSON hash with no name' do

      expected = get_fixture('treaty_with_no_name')

      expect(subject.to_yaml).to eq expected
    end
  end

  context 'partial data' do
    it 'produces the expected JSON hash with missing data' do

      expected = get_fixture('treaty_missing_data')

      expect(subject.to_yaml).to eq expected
    end
  end
end
