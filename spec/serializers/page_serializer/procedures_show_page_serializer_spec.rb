require_relative '../../rails_helper'

RSpec.describe PageSerializer::ProceduresShowPageSerializer, vcr: true do
  include_context "sample request", include_shared: true

  let(:response) {Parliament::Request::UrlRequest.new(base_url:   ENV['PARLIAMENT_BASE_URL'],
                                                      builder:    Parliament::Builder::NTripleResponseBuilder,
                                                      decorators: Parliament::Grom::Decorator).procedure_by_id.set_url_params({ procedure_id: 'iWugpxMn' }).get}

  let(:procedure) {response.filter('https://id.parliament.uk/schema/Procedure').first}

  subject { described_class.new(request: request, procedure: procedure) }

  describe '#to_h' do
    it 'produces the expected JSON hash' do

      expected = get_fixture('fixture')

      expect(subject.to_yaml).to eq expected
    end

    context 'with no name' do
      it 'produces the expected JSON hash with no name' do

        expected = get_fixture('procedure_with_no_name')

        expect(subject.to_yaml).to eq expected
      end
    end

    context 'with no description' do
      it 'produces the expected JSON hash' do

        expected = get_fixture('procedure_with_no_description')

        expect(subject.to_yaml).to eq expected
      end
    end
  end
end
